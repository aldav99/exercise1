shared_examples_for "API Show Authorizable" do |class_name_as_string, nested_level = 1|
  
  before do
    do_request(access_token: access_token.token)
    if nested_level != 0
      @path = "#{class_name_as_string}/0"
    else
      @path = "#{class_name_as_string}"
    end
  end

  context 'authorized' do

    it 'returns 200 status code' do
      expect(response).to be_success
    end

    it "returns only one #{class_name_as_string.singularize}" do
      expect(response.body).to have_json_size(1)
    end

    context 'attachments' do
      it "returns 2 attachments" do
        expect(response.body).to have_json_size(2).at_path("#{@path}/attachments")
      end

      %w(file).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(attachment2.send(attr.to_sym).to_json).at_path("#{@path}/attachments/0/#{attr}")
        end
      end
    end

    context 'comments' do
      it "returns 2 comments" do
        expect(response.body).to have_json_size(2).at_path("#{@path}/comments")
      end

      %w(id body user_id commentable_type commentable_id created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(comment2.send(attr.to_sym).to_json).at_path("#{@path}/comments/0/#{attr}")
        end
      end
    end
  end
end
# -------------------------------------------------------------------
# -------------------------------------------------------------------
