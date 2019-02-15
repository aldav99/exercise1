class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question
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
  # accepts_nested_attributes_for :attachments, reject_if: proc { |attr| attr['file'].nil? }, allow_destroy: true

  after_create :update_reputation

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
