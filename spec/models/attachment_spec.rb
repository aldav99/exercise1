require 'rails_helper'

describe Attachment do
  it { should belong_to :attachmentable }
  it { should validate_presence_of :file }
end
