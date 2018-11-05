class Attachment < ApplicationRecord
  # belongs_to :attachmentable, polymorphic: true
  belongs_to :question
  mount_uploader :file, FileUploader
end
