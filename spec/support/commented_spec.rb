require 'rails_helper'

shared_examples "commented" do
  let(:user_comment) { create(:user)}
  # sign_in_user
  let(:model) { described_class }
  let(:commentable) { create(model.controller_name.classify.constantize.to_s.underscore.to_sym)}

  before { sign_in(user_comment) }

  describe 'post :add_comment' do
    context 'fill to body' do
      it "responds with success" do
        expect { post :add_comment, params: {id: commentable, comment: attributes_for(:comment) }, format: :json }.to change(commentable.comments, :count).by(1)
      end
    end

    context 'Null body' do
      it "responds with error" do
        post :add_comment, params: {id: commentable, comment: attributes_for(:invalid_comment), format: :json}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
