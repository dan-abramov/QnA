class NewAnswerMailer < ApplicationMailer
  def notificate(subscriber)
    mail to: subscriber.user.email
  end
end
