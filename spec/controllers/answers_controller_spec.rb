require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:author) { create(:user_with_answers) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: author ) }

  describe 'GET #edit' do

    it_behaves_like "edited", model: Answer

    def do_request(options = {})
      get :edit, params: { question_id: question }.merge(options)
    end
  end

  describe 'POST #create' do

  it_behaves_like 'created', model: Answer, format: :js

    def do_request(options = {})
      post :create, params: { question_id: question, format: :js }.merge(options)
    end
  end

  describe ' #best' do
    before do
      @author_question = create(:question, user: author )
      @answer = create(:answer, question: @author_question )
    end

    context 'Author' do
      before {sign_in(author)}
      
      it 'method best change field best of answer' do
        get :best, params: {id: @answer}, format: :js
        @answer.reload
        expect(@answer.best).to eq true
      end

      it 'render best template' do
        get :best, params: {id: @answer}, format: :js
        expect(response).to render_template :best
      end
    end

    context 'Non Author' do
      sign_in_user
      
      it 'method best not change field best of answer' do
        get :best, params: {id: @answer}, format: :js
        @answer.reload
        expect(@answer.best).to eq false
      end

      it 'render best template' do
        get :best, params: {id: @answer}, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it_behaves_like 'updated', model: Answer, format: :js
      before { sign_in(author) }
      
      it 'assigns th question' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:question)).to eq question
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'deleted', model: Answer, format: :js
  end
  
  it_behaves_like "voted"
end
