class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy


  validates :body, presence: true

  scope :former_best, -> { where(best: true) }

  def toggle_best
    former_best = self.question.answers.former_best.first 
    
    Answer.transaction do
      former_best.update!(best: false) if former_best
      self.update!(best: true)
    end
  end

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_commit :update_reputation, on: :create
  after_commit :send_new_answer_notification, on: :create


  private

  def send_new_answer_notification
    NewAnswerNotificationJob.perform_now(self)
  end

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
