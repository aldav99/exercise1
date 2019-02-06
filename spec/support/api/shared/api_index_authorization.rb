shared_examples_for "API Index Authorizable" do |class_name_as_string|
  
  before do
    @object_name = class_name_as_string.singularize.to_sym
    do_request(access_token: access_token.token)
  end

  context 'authorized' do

    it 'returns 200 status code' do
      expect(response).to be_success
    end

    it "returns list of #{class_name_as_string.pluralize}" do
      expect(response.body).to have_json_size(2).at_path("#{class_name_as_string}")
    end

    %w(id title body created_at updated_at correct best user_id).each do |attr|
      it "#{class_name_as_string.singularize} object contains #{attr}" do
        expect(response.body).to be_json_eql(@object_name.send(attr.to_sym).to_json).at_path("#{class_name_as_string}/0/#{attr}") if @object_name.respond_to? attr.to_sym
      end
    end
  end
end