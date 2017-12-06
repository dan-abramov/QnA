class QuestionUpdateMailer < ApplicationMailer
  def notificate(subscription)
    @question = subscription.question
    mail to: subscription.user.email
  end
end
