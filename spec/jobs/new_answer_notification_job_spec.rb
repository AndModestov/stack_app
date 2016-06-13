require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:user){ create(:user) }
  let(:other_user){ create(:user) }
  let(:question){ create(:question, user: user) }
  let(:answer){ create(:answer, user: user, question: question) }

  it 'sends new_answer notification email' do
    create(:subscription, question_sub_id: question.id, sub_user_id: other_user.id)

    message1 = double(NotificationMailer.new_answer(answer.id, user.id))
    message2 = double(NotificationMailer.new_answer(answer.id, other_user.id))

    allow(NotificationMailer).to receive(:new_answer).with(answer.id, user.id).and_return(message1)
    allow(NotificationMailer).to receive(:new_answer).with(answer.id, other_user.id).and_return(message2)

    expect(message1).to receive(:deliver_later)
    expect(message2).to receive(:deliver_later)

    NewAnswerNotificationJob.perform_now(answer)
  end
end
