class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    NotificationMailer.new_answer(answer.id).deliver_later
  end
end
