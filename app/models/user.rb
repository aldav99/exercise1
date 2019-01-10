class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :vkontakte] #, :facebook]

  has_many :answers
  has_many :comments
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations

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
        # user = User.create!(email: email, password: password, password_confirmation: password)
        user = User.new(email: email, password: password, password_confirmation: password)
        if auth.create_email
          user.send_confirmation_instructions
        else
          user.skip_confirmation!
        end
        user.save
        user.create_authorization(auth)
      end
    else
      return false
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def first_authorization_without_email?(auth)
    auth.create_email
  end

  def skip_confirmation!
    self.confirmed_at = Time.now
  end
end
