# class DailyMailer < ApplicationMailer

#   default from: "from@example.com"

#   # Subject can be set in your I18n file at config/locales/en.yml
#   # with the following lookup:
#   #
#   #   en.daily_mailer.digest.subject
#   #
#   def digest(user)
#     @greet = "Hi"
#     @priv = user.email

#     mail to: user.email
#   end
# end
class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @user = user
    @questions = questions

    mail(to: @user.email, subject: 'Daily updates')
  end
end