require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:author) { create(:user_with_answers) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: author ) }

  describe 'GET #edit' do
    
    before { get :edit, params: { question_id: question, id: answer } }

    it 'assigns the requested answer to answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database (relationship belongs_to question)' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer in the database (relationship belongs_to user)' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template :create
      end
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
        expect(response).to render_template :best
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      
      before do
        sign_in(author)
      end
      
      it 'assigns the requested answer to answer' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns th question' do
        # patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'change answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new text'}}, format: :js
        answer.reload
        expect(answer.body).to eq 'new text'
      end

      it 'render update template' do
        patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before do
        sign_in(author)
        patch :update, params: {id: answer, answer: {body: nil}}, format: :js
      end
      
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to match(/answeranswer/)
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
        # expect(response).to render_template :edit
      end
    end

    context 'Non Author' do
      sign_in_user

      it "no edit another user's answer" do
        patch :update, params: {id: author.answers[0], answer: {body: "other user text"}}, format: :js
        answer.reload
        expect(author.answers[0].body).to match(/answeranswer/)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(author)
    end

    context 'Author' do
      it 'deletes answer' do
        expect { delete :destroy, params: { id: author.answers[0] }, format: :js}.to change(author.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: author.answers[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Non Author' do
      sign_in_user

      it "no deletes another user's answer" do
        author_answer = author.answers[0]
        expect { delete :destroy, params: { id: author_answer }, format: :js}.not_to change(author.answers, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: author.answers[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
  
  it_behaves_like "voted"
end
