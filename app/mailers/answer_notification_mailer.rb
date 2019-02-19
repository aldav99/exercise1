class AnswerNotificationMailer < ApplicationMailer
  def notification(answer)
    @answer = answer
    @question = @answer.question
    @user = @question.user

    mail(to: @user.email, subject: 'New answer to your question')
  end
end