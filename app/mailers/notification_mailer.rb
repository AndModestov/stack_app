class NotificationMailer < ApplicationMailer
  def new_answer(answer_id, user_id)
    @answer = Answer.find(answer_id)
    @user = User.find(user_id)

    mail(to: @user.email, subject: 'StackApp. New answer for your question')
  end
end
