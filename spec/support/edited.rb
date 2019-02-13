require 'rails_helper'

shared_examples "edited" do |model:|

  singular = model.name.singularize.underscore.to_sym

  let(:author_record) { create(:user) }
  let(:record) { create(singular, user: author_record) }

  before { do_request(:id => record) }

  before do 
    sign_in(author_record)
    do_request(id: record)
  end

  it 'renders edit view' do
    expect(response).to render_template :edit
  end

  it "assigns the requested #{singular} to #{singular}" do
    expect(assigns(singular)).to eq record
  end
end
