require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:subscribered_user) { create(:user) }
  let!(:subscriber) { create(:subscriber, question: question, user: subscribered_user)}
  let!(:answer) {create(:answer, question: question)}
  let!(:foreign_users) { create_list(:user, 2) }

  it 'send answer notification for subscribered user' do
    expect(AnswerNotificationMailer).to receive(:notification).with(answer, subscribered_user).and_call_original
    NewAnswerNotificationJob.perform_now(answer)
  end


  it 'not sends to not-subscribers' do
    foreign_users.each do |fuser|
      expect(AnswerNotificationMailer).to_not receive(:notification).with(answer, fuser)
    end
    NewAnswerNotificationJob.perform_now(answer)
  end
end