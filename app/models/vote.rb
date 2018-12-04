class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: {scope: [:votable_type, :votable_id]}
  validate :user_no_author
    
  def user_no_author
    if user.author_of?(votable)
      errors.add(:user_id, "can't be author")
    end
  end
end

