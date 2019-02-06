shared_examples_for "API Authorizable" do |class_name_as_string|
  
  before do
    @object_name = class_name_as_string.to_sym
    @invalid_object = ('invalid_' + class_name_as_string).to_sym
    @klass = class_name_as_string.classify.constantize
    @fix_object = ('fix_' + class_name_as_string).to_sym
  end

  context 'authorized' do
    it 'returns 200 status code' do
      do_request_post(@object_name => attributes_for(@object_name))
      expect(response).to be_success
    end

    it 'returns failure status code' do
      invalid_object = 'invalid_' + class_name_as_string
      do_request_post(@object_name => attributes_for(@invalid_object))
      expect(response).to_not be_success
    end

    it "returns new #{class_name_as_string}" do
      do_request_post(@object_name => attributes_for(@object_name))
      expect(response).to match_response_schema(class_name_as_string)
    end

    it "saves the new #{class_name_as_string} in the database" do
      expect { do_request_post(@object_name => attributes_for(@object_name)) }.to change(@klass, :count).by(1)
    end

    it "does not save the #{class_name_as_string} with invalid attributes" do
      expect { do_request_post(@object_name => attributes_for(@invalid_object)) }.to_not change(@klass, :count)
    end

    context 'output of authorized user' do

      before do
        @object = create(@fix_object)
        do_request_post(@object_name => attributes_for(@fix_object))
      end

      %w(title body body correct best).each do |attr|
      it "#{class_name_as_string} object contains #{attr}" do
          expect(response.body).to be_json_eql(@object.send(attr.to_sym).to_json).at_path("#{class_name_as_string}/#{attr}") if @object.respond_to? attr.to_sym
        end
      end
    end
  end
end
