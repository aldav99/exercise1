require 'rails_helper'

shared_examples_for "updated" do |model:, format: :html|

  singular = model.name.singularize.underscore.to_sym
  invalid = ('invalid_' + singular.to_s).to_sym
  let(:author_record) { create(:user) }
  let(:record) { create(singular, user: author_record) }

  let(:valid_attributes) { attributes_for(singular) }
  let(:invalid_attributes) { attributes_for(invalid) }

  before do
    sign_in(author_record)
  end

  context 'valid attributes' do
    it "assigns the requested #{singular} to #{singular}" do
      patch :update, params: { :id => record,
                              singular => attributes_for(singular)}, format: format
      expect(assigns(singular)).to eq record
    end

    it "change #{singular} attributes" do
      patch :update, params: {:id => record, 
                              singular => valid_attributes}, format: format
      record.reload
      expect(record).to have_attributes(valid_attributes)
    end

    it 'right render or redirect' do
      patch :update, params: {:id => record, 
                              singular => valid_attributes}, format: format
      expect(response).to render_template :update
    end
  end

  context 'invalid attributes' do
    it "does not change #{singular} attributes" do
      expect {
          patch :update, params: { :id => record,
                                    singular => invalid_attributes }, format: format
        }.not_to change { record.reload.attributes }
    end

    it 're-renders edit view' do
      patch :update, params: { :id => record,
                                singular => invalid_attributes }, format: format
      expect(response).to render_template :update
    end
  end

  context 'Non Author' do
    sign_in_user

    it "no edit another user's #{singular}" do
      expect {
          patch :update, params: { :id => record,
                                    singular => valid_attributes }, format: format
        }.not_to change { record.reload.attributes }
    end
  end
end

  # describe 'PATCH #update' do
    
  #   before do
  #     sign_in(author)
  #     @author_question = author.questions[0]
  #   end

  #   it_behaves_like 'updated', model: Question

  #   context 'valid attributes' do

  #     it 'redirects to the updated question' do
  #       patch :update, params: {id: @author_question, question: attributes_for(:question)}, format: :js
  #       expect(response).to redirect_to @author_question
  #     end
  #   end

  #   context 'Non Author' do
  #     sign_in_user
  #     before {patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}, format: :js
  #     }

      # it 're-renders edit view' do
      #   expect(response).to render_template :update
      # end
  #   end
  # end
#----------------------------------------------------

  # describe 'PATCH #update' do
  #   context 'valid attributes' do
  #     it_behaves_like 'updated', model: Answer
  #     before { sign_in(author) }
      
  #     it 'assigns th question' do
  #       patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
  #       expect(assigns(:question)).to eq question
  #     end

      # it 'render update template' do
      #   patch :update, params: {id: answer, answer: attributes_for(:answer)}, format: :js
      #   expect(response).to render_template :update
      # end
  #   end
  # end



