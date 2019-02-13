require 'rails_helper'

shared_examples_for "created" do |model:, format: :html|

  singular = model.name.singularize.underscore.to_sym
  plural = model.name.pluralize.underscore.to_sym

  invalid = ('invalid_' + singular.to_s).to_sym

  redirect_path = singular.to_s + "_path(assigns(singular))"

  let(:valid_attributes) { attributes_for(singular) }
  let(:invalid_attributes) { attributes_for(invalid) }

  sign_in_user

  context 'with valid attributes' do
    it "saves the new #{singular} in the database" do
      expect{ do_request(singular => valid_attributes) }.to change(model, :count).by(1)
    end

    it "saves the new #{singular} in the database (relationship belongs_to user)" do
      expect { do_request(singular => valid_attributes) }.to change(@user.send(plural), :count).by(1)
    end

    it 'render create template' do
      do_request(singular => valid_attributes)
      if format == :js
        expect(response).to render_template :create
      else
        expect(response).to redirect_to(eval(redirect_path))
      end
    end

    context 'with invalid attributes' do
      it "does not save the #{singular}" do
        expect{ do_request(singular => invalid_attributes) }.to_not change(model, :count)
      end

      it 'render create template' do
        do_request(singular => invalid_attributes)
        if format == :js
          expect(response).to render_template :create
        else
          expect(response).to render_template(:new)
        end
      end
    end
  end
end

