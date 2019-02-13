require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do

  describe 'GET #github' do
    it_behaves_like 'provided', provider: :github
  end

  describe 'GET #github user is present' do
    it_behaves_like 'provided', provider: :github, user_present: true
  end

  describe 'GET #vkontakte' do
    it_behaves_like 'provided', provider: :vkontakte
  end

  describe 'GET #create_email' do
    it_behaves_like 'provided', provider: :create_email
  end
end

