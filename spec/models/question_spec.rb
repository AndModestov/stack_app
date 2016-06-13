require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(90) }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy)}

  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:comments).dependent(:destroy) }

  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many :sub_users }

  describe 'subscribe_to_question' do
    let(:user){ create(:user) }

    it 'subscribes user to question' do
      question = Question.new(title: 'test-title', body: 'test-body', user: user)

      expect{ question.save! }.to change(user.subscriptions, :count).by(1)
    end
  end

  it_behaves_like 'votable' do
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let!(:votable){ create(:question, user: user2) }
  end
end
