class Question < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end
