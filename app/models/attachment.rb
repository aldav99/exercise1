class Attachment < ApplicationRecord
  validates :file, presence: true
  
  belongs_to :attachmentable, polymorphic: true, optional: true
  mount_uploader :file, FileUploader
end
