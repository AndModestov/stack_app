require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  describe 'author_of? method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let(:answer){ create(:answer, question: question, user: user)}
    let(:user2){ create(:user) }
    let(:question2){ create(:question, user: user2) }
    let(:answer2){ create(:answer, question: question2, user: user2)}

    it 'should return true when User is author of question/answer' do
      expect(user.author_of?(question)).to be true
      expect(user.author_of?(answer)).to be true
    end

    it 'should return false when User is not author of question/answer' do
      expect(user.author_of?(question2)).to be false
      expect(user.author_of?(answer2)).to be false
    end
  end
end