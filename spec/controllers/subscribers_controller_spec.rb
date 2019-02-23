require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do

  let!(:question) { create(:question) }
  let!(:author) { create(:user) }
  let!(:author_question) { create(:question, user: author) }
  let!(:subscriber) { create(:subscriber, question: question, user: author) }


  describe 'POST #create' do
    context 'any signed_in user' do
      sign_in_user
      it 'registered user can subscribe' do
        expect { post :create, params: { question_id: question } }.to change(question.subscribers, :count).by(1)
      end

      it 'render right template' do
        post :create, params: { question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'author' do
      before {sign_in(author)}
      it 'author can not subscribe' do
        expect { post :create, params: { question_id: author_question } }.to_not change(author_question.subscribers, :count)
      end

      it 'render right template' do
        post :create, params: { question_id: author_question }
        expect(response).to redirect_to author_question
      end
    end

    context 'not signed_in user' do
      it 'unregistered user can not subscribe' do
        expect { post :create, params: { question_id: question } }.to_not change(question.subscribers, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'any signed_in subscribed user' do

      before {sign_in(author)}

      it 'registered user can unsubscribe' do
        expect { delete :destroy, params: { id: subscriber } }.to change(question.subscribers, :count).by(-1)
      end

      it 'render right template' do
        delete :destroy, params: { id: subscriber }
        expect(response).to redirect_to question
      end
    end
  end
end