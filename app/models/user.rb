class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers
  has_many :comments
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(obj)
    self.id == obj.user_id if obj.respond_to?(:user_id)
  end
end
