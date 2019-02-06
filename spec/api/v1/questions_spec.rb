require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"
    it_behaves_like "API Index Authorizable", 'questions'

    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.first }
    let!(:answer) { create(:answer, question: question) }

    context 'authorized answer prove' do
      before { get '/api/v1/questions', params: {format: :json, access_token: access_token.token} }

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
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }
    let!(:attachment1) { create(:attachment, attachmentable: question) }
    let!(:attachment2) { create(:attachment, attachmentable: question) }
    let(:access_token) { create(:access_token) }
    let!(:comment1) { create(:comment, user: user, commentable: question) }
    let!(:comment2) { create(:comment, user: user, commentable: question) }

    it_behaves_like "API Show Authorizable", 'questions'

    def do_request(options = {})
      get '/api/v1/questions', params: {id: question, format: :json}.merge(options)
    end
  end

  describe 'POST /create' do

    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable", 'question'

    def do_request(options = {})
      post '/api/v1/questions', params: {format: :json}.merge(options)
    end

    def do_request_post(options = {})
      post '/api/v1/questions', params: {format: :json, access_token: access_token.token}.merge(options)
    end
  end
end


