require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  before(:each) do
    @question = create(:question)
    @answer = create(:answer, question: @question)
    @answers =  create_list(:answer, 2, question: @question) << @answer
  end

  describe 'GET #index' do

    before { get :index, params: { question_id: @question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(@answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { question_id: @question, id: @answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq @answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: @question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    
    before { get :edit, params: { question_id: @question, id: @answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq @answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before do
      user = create(:user)
      allow_any_instance_of(AnswersController).to receive(:current_user) { user }
    end
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { user_id: @current_user, question_id: @question, answer: attributes_for(:answer) } }.to change(@question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: @question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_answers_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: @question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: @question, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: {id: @answer, answer: attributes_for(:answer)}
        expect(assigns(:answer)).to eq @answer
      end

      it 'change answer attributes' do
        patch :update, params: {id: @answer, answer: {body: 'new text'}}
        @answer.reload
        expect(@answer.body).to eq 'new text'
      end

      it 'redirects to the updated answer' do
        patch :update, params: {id: @answer, answer: attributes_for(:answer)}
        expect(response).to redirect_to @answer
      end
    end

    context 'invalid attributes' do
      before {patch :update, params: {id: @answer, answer: {body: nil}}}
      
      it 'does not change answer attributes' do
        @answer.reload
        expect(@answer.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @user = create(:user)
      allow_any_instance_of(AnswersController).to receive(:current_user) { @user }
    end

    before { @answer }
    before { @user.answers << @answer }

    it 'deletes answer' do
      expect { delete :destroy, params: { id: @answer }}.to change(@user.answers, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: @answer }
      expect(response).to redirect_to question_answers_path(@answer.question)
    end
  end
end
