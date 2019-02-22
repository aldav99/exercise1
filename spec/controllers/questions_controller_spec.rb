require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }
  let(:author) { create(:user_with_questions) }

  describe 'GET #index' do
    it_behaves_like "indexed", model: Question
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

  describe 'POST #subscribe' do
    context 'any signed_in user' do
      sign_in_user
      it 'registered user can subscribe' do
        expect { post :subscribe, params: { id: question } }.to change(question.subscribers, :count).by(1)
      end

      it 'render right template' do
        post :subscribe, params: { id: question }
        expect(response).to redirect_to question
      end
    end

    context 'author' do
      before {sign_in(author)}
      it 'author can not subscribe' do
        expect { post :subscribe, params: { id: author.questions[0] } }.to_not change(author.questions[0].subscribers, :count)
      end

      it 'render right template' do
        post :subscribe, params: { id: author.questions[0] }
        expect(response).to redirect_to author.questions[0]
      end
    end

    context 'not signed_in user' do
      it 'unregistered user can not subscribe' do
        expect { post :subscribe, params: { id: question } }.to_not change(question.subscribers, :count)
      end
    end
  end

  describe 'POST #unsubscribe' do
    context 'any signed_in subscribed user' do
      sign_in_user
      before { post :subscribe, params: { id: question } }

      it 'registered user can unsubscribe' do
        expect { post :unsubscribe, params: { id: question } }.to change(question.subscribers, :count).by(-1)
      end

      it 'render right template' do
        post :unsubscribe, params: { id: question }
        expect(response).to redirect_to question
      end
    end

    context 'not signed_in user' do
      it 'unregistered user can not unsubscribe' do
        expect { post :unsubscribe, params: { id: question } }.to_not change(question.subscribers, :count)
      end
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

