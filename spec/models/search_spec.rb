require 'rails_helper'

RSpec.describe Search, type: :model do

  it 'send request ALL' do
    request = "sidekiq"
    escape_query = ThinkingSphinx::Query.escape(request)

    expect(ThinkingSphinx).to receive(:search).with(escape_query).and_call_original

    Search.query(request, "all")
  end

  %w( question answer comment user).each do |choice|
    it "send request with right area:  #{choice}" do
      request = "sidekiq"
      escape_query = ThinkingSphinx::Query.escape(request)
    
      expect(choice.classify.constantize).to receive(:search).with(escape_query).and_call_original

      Search.query(request, choice)
    end
  end

  it "send request with invalid area" do
    request = "sidekiq"
    escape_query = ThinkingSphinx::Query.escape(request)
  
    expect(ThinkingSphinx).to_not receive(:search).with(escape_query)

    Search.query(request, "another")
  end
end