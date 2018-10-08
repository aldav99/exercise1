require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  before(:each) do
    @question = create(:question)
    @answer = create(:answer, question: @question)
    @answers =  create_list(:answer, 2, question: @question) << @answer
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
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database (relationship belongs_to question)' do
        expect { post :create, params: { question_id: @question, answer: attributes_for(:answer) } }.to change(@question.answers, :count).by(1)
      end

      it 'saves the new answer in the database (relationship belongs_to user)' do
        expect { post :create, params: { question_id: @question, answer: attributes_for(:answer) } }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: @question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path @question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: @question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: @question, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question_path @question
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
        expect(@answer.body).to match(/answeranswer/)
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @author = create(:user_with_answers)
      sign_in(@author)
    end

    context 'Author' do
      it 'deletes answer' do
        expect { delete :destroy, params: { id: @author.answers[0] }}.to change(@author.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @author.answers[0] }
        expect(response).to redirect_to question_path(@author.answers[0].question)
      end
    end

    context 'Non Author' do
      sign_in_user

      it "no deletes another user's answer" do
        @author_answer = @author.answers[0]
        expect { delete :destroy, params: { id: @author_answer }}.not_to change(@author.answers, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @author.answers[0] }
        expect(response).to redirect_to question_path(@author.answers[0].question)
      end
    end
  end
end
