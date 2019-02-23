class Question < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation
  after_create :subscribe_author

  def subscriber(user)
    self.subscribers.where(user_id: user.id).first
  end

  private

  def subscribe_author
    self.subscribers.create(user_id: self.user.id)
  end

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
