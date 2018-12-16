class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers_#{data['id'].to_i}"
  end
end