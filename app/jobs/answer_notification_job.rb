class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      QuestionUpdateMailer.notificate(subscription).deliver_later unless subscription.user.author_of?(answer)
    end
  end
end
