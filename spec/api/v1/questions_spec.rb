require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: {format: :json}.merge(options)
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:question) { create(:question) }

      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: {id: question, format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: {id: question, format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:attachment1) { create(:attachment, attachmentable: question) }
      let!(:attachment2) { create(:attachment, attachmentable: question) }
      let(:access_token) { create(:access_token) }
      let!(:comment1) { create(:comment, user: user, commentable: question) }
      let!(:comment2) { create(:comment, user: user, commentable: question) }

      before { get '/api/v1/questions', params: {id: question, format: :json, access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns only one question' do
        expect(response.body).to have_json_size(1)
      end

      context 'attachments' do
        it "returns 2 attachments" do
          expect(response.body).to have_json_size(2).at_path("questions/0/attachments")
        end

        %w(file).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment2.send(attr.to_sym).to_json).at_path("questions/0/attachments/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it "returns 2 comments" do
          expect(response.body).to have_json_size(2).at_path("questions/0/comments")
        end

        %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment2.send(attr.to_sym).to_json).at_path("questions/0/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do

      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status code' do
        post '/api/v1/questions', params: {question: attributes_for(:question), format: :json, access_token: access_token.token} 
        expect(response).to be_success
      end

      it 'returns new question' do
        post '/api/v1/questions', params: {question: attributes_for(:question), format: :json, access_token: access_token.token} 
        expect(response).to match_response_schema('question')
      end

      it 'saves the new question in the database' do
        expect { post '/api/v1/questions', params: {question: attributes_for(:question), format: :json, access_token: access_token.token} }.to change(Question, :count).by(1)
      end

      it 'does not save the question with invalid attributes' do
        expect { post '/api/v1/questions', params: {question: attributes_for(:invalid_question), format: :json, access_token: access_token.token} }.to_not change(Question, :count)
      end

      it 'returns failure status code' do
        post '/api/v1/questions', params: {question: attributes_for(:invalid_question), format: :json, access_token: access_token.token}
        expect(response).to_not be_success
      end
    end

    context 'output of authorized user' do
      let!(:question) { create(:fix_question) }
      let(:access_token) { create(:access_token) }
      before {post '/api/v1/questions', params: {question: attributes_for(:fix_question), format: :json, access_token: access_token.token}}

      %w(title body).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end
end


