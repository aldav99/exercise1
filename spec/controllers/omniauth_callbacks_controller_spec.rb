require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #github' do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      get :github
    end

    it 'render email template' do
      expect(response).to render_template 'omniauth_callbacks/email'
    end
  end

  describe 'GET #github user is present' do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      user.authorizations.create(provider: request.env['omniauth.auth'].provider, uid: request.env['omniauth.auth'].uid)
      get :github
    end

    it 'no add User' do
      expect {get :github }.not_to change {User.count}
    end

    it 'render email template' do
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #vkontakte' do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:vkontakte]
    end

    it 'add User' do
      expect {get :vkontakte }.to change {User.count}.by(1)
    end

    it 'right render' do
      get :vkontakte
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #create_email' do

    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:create_email]
    end

    it 'add User' do
      expect {get :create_email }.to change {User.count}.by(1)
    end

    it 'right render' do
      get :create_email
      expect(response).to redirect_to(root_path)
    end
  end
end

