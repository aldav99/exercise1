class SpecialQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title
  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable

  def short_title
    object.title.truncate(10)
  end
end
