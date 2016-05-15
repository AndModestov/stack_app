require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should validate_presence_of :question_id }
  it { should belong_to(:question) }

  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  it { should have_many(:votes) }

  describe 'best_answer! method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let!(:answer1){ create(:answer, question: question, user: user, best: false) }
    let!(:answer2){ create(:answer, question: question, user: user, best: true) }

    it 'should make answer the best' do
      expect{ answer1.best_answer! }.to change { answer1.best }.from(false).to(true)
    end

    it 'should change the best answer' do
      answer1.best_answer!
      answer2.reload

      expect(answer1.best).to be true
      expect(answer2.best).to be false
    end
  end

  describe 'best_first method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let!(:answers){ create_list(:answer, 4, question: question, user: user) }

    it 'should move best answer up' do
      new_answer = create(:answer, question: question, user: user, best: true)
      expect(question.answers.last).to eq new_answer
      expect(question.answers.best_first.first).to eq new_answer
    end
  end
end
