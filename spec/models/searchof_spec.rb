require 'rails_helper'

RSpec.describe Searchof, type: :model do

  it 'send request' do
    request = "sidekiq"
    escape_query = ThinkingSphinx::Query.escape(request)

    expect(ThinkingSphinx::Query).to receive(:escape).with(request).and_call_original
    expect(ThinkingSphinx).to receive(:search).with(escape_query)

    Searchof.query(request, "all")
  end
end