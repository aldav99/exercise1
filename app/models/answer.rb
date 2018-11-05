class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :body, presence: true

  scope :former_best, -> { where(best: true) }

  def toggle_best
    former_best = self.question.answers.former_best.first 
    
    Answer.transaction do
      former_best.update!(best: false) if former_best
      self.update!(best: true)
    end
  end

  accepts_nested_attributes_for :attachments
end
