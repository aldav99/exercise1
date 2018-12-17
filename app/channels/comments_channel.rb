class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_question_#{data['id'].to_i}"
  end
end