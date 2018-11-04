class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :former_best, -> { where(best: true) }

  def toggle_best
    former_best = self.question.answers.former_best.first 
    
    Answer.transaction do
      if former_best 
        former_best.update!(best: false)
      end
      
      self.update!(best: true)
    end
  end
end
