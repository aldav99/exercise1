class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :former_best, -> { where(best: true) }

  def self.flip_best(answer)
    former_best = Answer.former_best.first
    
    if former_best 
      former_best.best = false
      former_best.save
    end
    
    answer.best = true
    answer.save
  end
end
