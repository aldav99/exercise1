class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    end
  end

  def github
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'github') if is_navigational_format?
    else
      session["devise.provider"] = auth.provider
      session["devise.uid"] = auth.uid
      flash[:notice] = 'Promt your Email'
      render 'omniauth_callbacks/email', locals: { auth: auth }
    end
  end

  def create_email
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'create_email') if is_navigational_format?
    end
  end

  private

  def auth
    params[:auth]["provider"] = session["devise.provider"] if params[:auth]
    params[:auth]["uid"] = session["devise.uid"] if params[:auth]
    params[:auth]["create_email"] = true if params[:auth]
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end

