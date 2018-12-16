class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment_#{data['id'].to_i}"
  end
end