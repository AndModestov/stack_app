class NewAnswerNotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(answer)
    users = Answer.find(answer.id).question.sub_users

    users.each do |user|
      NotificationMailer.new_answer(answer.id, user.id).deliver_later
    end
  end
end
