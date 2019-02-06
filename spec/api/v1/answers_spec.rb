require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question_with_answers) }
    let(:answer) { question.answers.first }
    
    it_behaves_like "API Authenticable"
    it_behaves_like "API Index Authorizable", 'answers'

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: {format: :json}.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let!(:attachment1) { create(:attachment, attachmentable: answer) }
    let!(:attachment2) { create(:attachment, attachmentable: answer) }
    let(:access_token) { create(:access_token) }
    let!(:comment1) { create(:comment, user: user, commentable: answer) }
    let!(:comment2) { create(:comment, user: user, commentable: answer) }


    it_behaves_like "API Authenticable"
    it_behaves_like "API Show Authorizable", 'answer', 0

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: {format: :json}.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question ) }
    let(:access_token) { create(:access_token) }
    let(:user) { create(:user) }


    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable", 'answer'

    def do_request(options = {})
      post '/api/v1/questions', params: {question: question, answer: attributes_for(:answer), format: :json}.merge(options)
    end

    def do_request_post(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: {format: :json, access_token: access_token.token}.merge(options)
    end
  end
end


