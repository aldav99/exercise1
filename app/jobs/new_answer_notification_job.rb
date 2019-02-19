class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    AnswerNotificationMailer.notification(answer).deliver_now
  end
end
