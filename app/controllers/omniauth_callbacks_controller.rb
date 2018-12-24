class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    end
  end

  def github
    # @user = User.find_for_oauth(request.env['omniauth.auth'])
    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    # end
    render json: request.env['omniauth.auth']
  end

  # def twitter
  #   render json: request.env['omniauth.auth']
  # end

  # def vkontakte
  #   render json: request.env['omniauth.auth']
  # end
end