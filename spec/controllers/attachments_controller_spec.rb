require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:author) { create(:user) }
  let!(:my_question) { create(:question, user: author) }
  let!(:my_attachment) { create(:attachment, attachmentable: my_question) }


  describe 'DELETE #destroy' do
    before do
      sign_in(author)
    end

    context 'Author' do
      it 'deletes my attachment' do
        expect { delete :destroy, params: { id: my_attachment } }.to change(Attachment, :count).by(-1)
      end

      it "redirect to quetion's show" do
        delete :destroy, params: { id: my_attachment }
        expect(response).to redirect_to my_question
      end
    end

    context 'Non Author' do
      sign_in_user

      it "no deletes another user's attachment" do
        expect { delete :destroy, params: { id: my_attachment }, format: :js }.to_not change(Attachment, :count)
      end

      it "redirect to quetion's show" do
        delete :destroy, params: { id: my_attachment }, format: :js 
        expect(response).to render_template :destroy
      end
    end
  end
end
