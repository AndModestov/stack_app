require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user){ create(:user) }
  let(:question){ create(:question, user: user) }
  let!(:answer){ create(:answer, user: user, question: question) }

  it 'sends new_answer notification email' do
    message = double(NotificationMailer.new_answer(answer.id))
    allow(NotificationMailer).to receive(:new_answer).with(answer.id).and_return(message)

    expect(message).to receive(:deliver_later)

    NewAnswerNotificationJob.perform_now(answer)
  end
end
