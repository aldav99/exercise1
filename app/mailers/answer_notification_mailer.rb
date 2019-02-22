class AnswerNotificationMailer < ApplicationMailer
  def notification(answer, user)
    @answer = answer
    @question = @answer.question
    @user = user

    mail(to: @user.email, subject: 'New answer to your question')
  end
end