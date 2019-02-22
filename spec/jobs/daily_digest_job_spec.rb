require 'rails_helper'
include ActiveJob::TestHelper


RSpec.describe DailyDigestJob, type: :job do
  ActiveJob::Base.queue_adapter = :test
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question) }  
  
  it 'should send digest to all users' do
    users.each do |user|
      perform_enqueued_jobs do
          DailyMailer.digest(user, [question.title]).deliver_later
      end

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq user.email
      expect(mail.body).to include question.title
    end
  end
end
