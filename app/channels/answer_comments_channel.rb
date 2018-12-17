class AnswerCommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_answer_#{data['id'].to_i}"
  end
end