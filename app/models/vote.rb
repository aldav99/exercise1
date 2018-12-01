class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: {scope: [:votable_type, :votable_id]}
  validate :user_no_author
    
  def user_no_author
    if user_id.present? && votable.user_id == user_id
      errors.add(:user_id, "can't be author")
    end
  end


  def self.vote_sum(votable)
    where(votable_type: votable.class.to_s, votable_id: votable.id).sum(&:vote)
  end
end

