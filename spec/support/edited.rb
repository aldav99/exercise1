require 'rails_helper'

shared_examples "edited" do
  it 'renders edit view' do
    expect(response).to render_template :edit
  end
end