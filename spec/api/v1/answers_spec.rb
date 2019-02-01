require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: {format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question_with_answers) }
      let(:answer) { question.answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(5).at_path("answers")
      end

      %w(id body created_at updated_at correct best user_id).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:answer) { create(:answer) }
      let!(:attachment1) { create(:attachment, attachmentable: answer) }
      let!(:attachment2) { create(:attachment, attachmentable: answer) }
      let(:access_token) { create(:access_token) }
      let!(:comment1) { create(:comment, user: user, commentable: answer) }
      let!(:comment2) { create(:comment, user: user, commentable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token} }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns only one answer' do
        puts "------------#{response.body}"
        expect(response.body).to have_json_size(1)
      end

      context 'attachments' do
        it "returns 2 attachments" do
          expect(response.body).to have_json_size(2).at_path("answer/attachments")
        end

        %w(file).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment2.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end

      context 'comments' do
        it "returns 2 comments" do
          expect(response.body).to have_json_size(2).at_path("answer/comments")
        end

        %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment2.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question ) }

      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', params: {question: question, answer: attributes_for(:answer), format: :json}
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', params: {question: question, answer: attributes_for(:answer), format: :json, access_token: '1234'}
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question ) }
      let(:access_token) { create(:access_token) }

      it 'returns 200 status code' do
        post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:answer), format: :json, access_token: access_token.token} 
        expect(response).to be_success
      end

      it 'returns new answer' do
        post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:answer), format: :json, access_token: access_token.token} 
        expect(response).to match_response_schema('answer')
      end

      it 'saves the new answer in the database' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:answer), format: :json, access_token: access_token.token} }.to change(Answer, :count).by(1)
      end

      it 'does not save the question with invalid attributes' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token} }.to_not change(Answer, :count)
      end

      it 'returns failure status code' do
        post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token}
        expect(response).to_not be_success
      end
    end

    context 'output of authorized user' do
      let(:user) { create(:user) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:fix_answer, user: user, question: question ) }
      let(:access_token) { create(:access_token) }
      before {post "/api/v1/questions/#{question.id}/answers", params: {answer: attributes_for(:fix_answer), format: :json, access_token: access_token.token}}

      %w(body correct best ).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end
end


