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


  describe 'Votes methods' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let(:user2){ create(:user) }
    let!(:answer){ create(:answer, question: question, user: user2) }

    describe 'voted_by?' do
      it 'should return true if answer is voted by user' do
        answer.votes.create(user: user, value: 1)
        expect(answer).to be_voted_by(user)
      end

      it 'should return false if answer is voted by user' do
        expect(answer).to_not be_voted_by(user)
      end
    end

    describe 'vote_up' do
      it 'should add + vote to answer' do
        expect{ answer.vote_up(user) }.to change(answer.votes, :count).by(1)
        expect(answer.votes.first.value).to be(1)
      end

      it 'shouldnt add + vote to voted answer' do
        answer.votes.create(user: user, value: 1)

        expect{ answer.vote_up(user) }.to_not change(answer.votes, :count)
      end
    end

    describe 'vote_down' do
      it 'should add - vote to answer' do
        expect{ answer.vote_down(user) }.to change(answer.votes, :count).by(1)
        expect(answer.votes.first.value).to be(-1)
      end

      it 'shouldnt add + vote to voted answer' do
        answer.votes.create(user: user, value: -1)

        expect{ answer.vote_down(user) }.to_not change(answer.votes, :count)
      end
    end

    describe 'delete_vote' do
      it 'should delete users vote' do
        answer.votes.create(user: user, value: 1)

        expect{ answer.delete_vote(user) }.to change(answer.votes, :count).by(-1)
        expect(Vote.count).to be 0
      end
    end

    describe 'total_score' do
      let!(:user3){ create(:user) }

      it 'should return votable total score' do
        answer.votes.create(user: user, value: -1)
        answer.votes.create(user: user3, value: -1)

        expect(answer.total_score).to eq -2
      end
    end
  end
end
