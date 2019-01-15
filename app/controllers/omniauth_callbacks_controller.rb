class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :invoke_provider, only: [:github, :vkontakte, :create_email]

  def vkontakte
  end

  def github
  end

  def create_email
  end

  private

  def auth
    params[:auth]["provider"] = session["devise.provider"] if params[:auth]
    params[:auth]["uid"] = session["devise.uid"] if params[:auth]
    params[:auth]["create_email"] = true if params[:auth]
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end

  def invoke_provider
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session["devise.provider"] = auth.provider
      session["devise.uid"] = auth.uid
      flash[:notice] = 'Promt your Email'
      render 'omniauth_callbacks/email', locals: { auth: auth }
    end
  end
end

