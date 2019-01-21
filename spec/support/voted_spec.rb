require 'rails_helper'

shared_examples "voted" do
  sign_in_user
  let(:model) { described_class }
  let(:user) { create(:user)}
  let(:votable) { create(model.controller_name.classify.constantize.to_s.underscore.to_sym)}

  describe 'post :vote_up' do
    context 'not author of votable' do
      it "responds with success" do
        post :vote_up, params: {id: votable, format: :json}
        expect(response).to have_http_status(:success)
      end
    end

    context 'author of votable' do
      before do
        sign_in(user)
        @author_votable = create(model.controller_name.classify.constantize.to_s.underscore.to_sym, user: user)
      end

      it "responds with error" do
        post :vote_up, params: {id: @author_votable, format: :json}
        # expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'post :vote_down' do
    context 'not author of votable' do
      it "responds with success" do
        post :vote_down, params: {id: votable, format: :json}
        expect(response).to have_http_status(:success)
      end
    end

    context 'author of votable' do
      before do
        sign_in(user)
        @author_votable = create(model.controller_name.classify.constantize.to_s.underscore.to_sym, user: user)
      end

      it "responds with error" do
        post :vote_down, params: {id: @author_votable, format: :json}
        # expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'post :vote_reset' do
    context 'not author of votable' do
      it "responds with success" do
        post :vote_down, params: {id: votable, format: :json}
        post :vote_reset, params: {id: votable, format: :json}
        expect(response).to have_http_status(:success)
      end
    end
  
    context 'author of votable' do
      before do
        sign_in(user)
        @author_votable = create(model.controller_name.classify.constantize.to_s.underscore.to_sym, user: user)
      end

      it "responds with error" do
        post :vote_reset, params: {id: @author_votable, format: :json}
        # expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to redirect_to root_url
      end
    end
  end
end

