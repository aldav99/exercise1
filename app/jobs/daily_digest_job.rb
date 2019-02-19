# class DailyDigestJob < ApplicationJob
#   queue_as :default

#   def perform
#     User.send_daily_digest
#   end
# end


class DailyDigestJob < ActiveJob::Base
  queue_as :mailers
  # queue_as :default

  def perform
    questions = Question.where(created_at: Time.now.all_day).pluck(:title)

    if questions.present?
      User.find_each do |user|
        DailyMailer.digest(user, questions).deliver_later
        # DailyMailer.digest(user, questions).deliver_now
      end
    end
  end
end