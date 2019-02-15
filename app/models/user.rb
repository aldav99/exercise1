class User < ApplicationRecord
  before_create :skip_confirmation!

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :vkontakte]#, skip: [:confirmation] #, :facebook]

  has_many :answers
  has_many :comments
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author_of?(obj)
    self.id == obj.user_id if obj.respond_to?(:user_id)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    if email
      user = User.where(email: email).first

      if user
        if auth.create_email
          user.update(confirmed_at: nil) 
          user.send_confirmation_instructions 
        end
        user.create_authorization(auth)
      else
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email, password: password, password_confirmation: password)
        user.save!
        if auth.create_email
          user.update(confirmed_at: nil)
          user.send_confirmation_instructions
          user.save!
        end
        user.create_authorization(auth)
      end
    else
      return false
    end

    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
