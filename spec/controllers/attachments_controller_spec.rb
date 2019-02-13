require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  it_behaves_like 'deleted', model: Attachment, format: :js
end
