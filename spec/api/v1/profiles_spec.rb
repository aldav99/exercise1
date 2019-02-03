require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/me', params: {format: :json}.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 5) }

      before do
        get '/api/v1/profiles', params: {format: :json, access_token: access_token.token}
        @parse_response = JSON.parse(response.body)
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it "response contains 5 users" do
        expect(response.body).to have_json_size(5).at_path("users")
      end


      it "response contains our's users" do
        users.each_index do |index|
          expect(@parse_response['users'][index].to_json).to be_json_eql(users[index].email.to_json).at_path('email')
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: {format: :json}.merge(options)
    end
  end
end