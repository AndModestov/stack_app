require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  it { should have_many(:votes) }

  it { should have_many(:comments) }

  describe 'author_of? method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let(:user2){ create(:user) }
    let(:question2){ create(:question, user: user2) }

    it 'should return true when User is author of question/answer' do
      expect(user).to be_author_of(question)
    end

    it 'should return false when User is not author of question/answer' do
      expect(user).to_not be_author_of(question2)
    end
  end
end