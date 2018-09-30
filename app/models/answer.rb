class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :correct, presence: true
end
