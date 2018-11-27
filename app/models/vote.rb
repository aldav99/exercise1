class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: {scope: [:votable_type, :votable_id]}


  def self.vote_sum(votable)
    where(votable_type: votable.class.to_s, votable_id: votable.id).sum(&:vote)
  end
end
