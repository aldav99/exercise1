require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:users_question) { create(:question, user: user) }

  let(:question) { create(:question) }
  let(:author) { create(:user_with_questions) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it_behaves_like "edited", model: Question

    def do_request(options = {})
      get :edit, params: options
    end
  end

  describe 'POST #create' do
    it_behaves_like 'created', model: Question

    def do_request(options = {})
      post :create, params: options
    end
  end

  describe 'PATCH #update' do
    
    before do
      sign_in(author)
      @author_question = author.questions[0]
    end

    it_behaves_like 'updated', model: Question, format: :js

    context 'Non Author' do
      sign_in_user
      before {patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}, format: :js
      }

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do

    it_behaves_like 'deleted', model: Question
  end
  
  it_behaves_like "voted"
  it_behaves_like "commented"
end

