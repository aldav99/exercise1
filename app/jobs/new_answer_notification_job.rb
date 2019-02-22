class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.each do |subscriber|
      AnswerNotificationMailer.notification(answer, subscriber.user).try(:deliver_later)
    end
  end
end
