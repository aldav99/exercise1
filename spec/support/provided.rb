shared_examples_for "provided" do |provider:, user_present: false|
  let!(:user) { create(:user) }
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
    if provider == :github && user_present
      user.authorizations.create(provider: request.env['omniauth.auth'].provider, uid: request.env['omniauth.auth'].uid)
    end
  end

  if provider != :github
    it 'add User' do
      expect {get provider }.to change(User, :count).by(1)
    end

    it 'right render' do
      get provider
      expect(response).to redirect_to(root_path)
    end
  end

  if provider == :github && !user_present
    it 'render email template' do
      get :github
      expect(response).to render_template 'omniauth_callbacks/email'
    end
  end

  if provider == :github && user_present
    it 'no add User' do
      get :github
      expect {get :github }.not_to change {User.count}
    end

    it 'render email template' do
      get :github
      expect(response).to redirect_to(root_path)
    end
  end
end