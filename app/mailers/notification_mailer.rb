class NotificationMailer < ApplicationMailer
  def new_answer(answer_id)
    @answer = Answer.find(answer_id)
    @user = @answer.question.user

    mail(to: @user.email, subject: 'StackApp. New answer for your question')
  end
end
