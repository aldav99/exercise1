require 'rails_helper'

shared_examples_for "deleted" do |model:, format: :html|

  singular = model.name.singularize.underscore.to_sym
  let(:author_record) { create(:user) }
  let(:record) { create(singular, user: author_record) }

  let!(:question) { create(:question, user: author_record) }
  
  if singular == :attachment
    let(:record) { create(singular, attachmentable: question) }
  else
    let(:record) { create(singular, user: author_record) }
  end

  context 'Author' do
    before { sign_in(author_record) }
    it "deletes the #{singular}" do
      record
      expect { delete :destroy, 
                      params: { id: record }, 
                      format: format}.to change(model, :count).by(-1)
    end


    it 'redirect to index view' do
      delete :destroy, 
              params: { id: record }, 
              format: format
      if format == :js
        expect(response).to render_template :destroy
      else
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'Non Author' do
    sign_in_user

    it "no deletes another user's #{singular}" do
      record
      expect { delete :destroy, 
                      params: { id: record }, 
                      format: format}.not_to change(model, :count)
    end

    it 'redirect to index view' do
      delete :destroy, params: { id: record }, format: format
      if format == :js
        expect(response).to have_http_status(:forbidden)
      else
        expect(response).to redirect_to root_path
      end
    end
  end
end
