require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users){ create_list(:user, 2) }
  let!(:questions){ create_list(:question, 2, user: users.first, created_at: (Time.now - 1.day)) }

  it 'sends digest email' do
    message = double(DailyMailer.delay)
    allow(DailyMailer).to receive(:delay).and_return(message)

    users.each do |user|
      expect(message).to receive(:digest).with(user, questions)
    end
    DailyDigestJob.perform_now
  end
end
