class SpecialAnswerSerializer < ActiveModel::Serializer
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
end
