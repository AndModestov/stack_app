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

  describe 'Votes methods' do
    let(:user){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question){ create(:question, user: user2) }

    describe 'voted_by?' do
      it 'should return true if question is voted by user' do
        question.votes.create(user: user, value: 1)
        expect(question).to be_voted_by(user)
      end

      it 'should return false if question is not voted by user' do
        expect(question).to_not be_voted_by(user)
      end
    end

    describe 'vote_up' do
      it 'should add + vote to question' do
        expect{ question.vote_up(user) }.to change(question.votes, :count).by(1)
        expect(question.votes.first.value).to be(1)
      end

      it 'shouldnt add + vote to voted question' do
        question.votes.create(user: user, value: 1)

        expect{ question.vote_up(user) }.to_not change(question.votes, :count)
      end
    end

    describe 'vote_down' do
      it 'should add - vote to answer' do
        expect{ question.vote_down(user) }.to change(question.votes, :count).by(1)
        expect(question.votes.first.value).to be(-1)
      end

      it 'shouldnt add + vote to voted answer' do
        question.votes.create(user: user, value: -1)

        expect{ question.vote_down(user) }.to_not change(question.votes, :count)
      end
    end

    describe 'delete_vote' do
      it 'should delete users vote' do
        question.votes.create(user: user, value: 1)

        expect{ question.delete_vote(user) }.to change(question.votes, :count).by(-1)
        expect(Vote.count).to be 0
      end
    end

    describe 'total_score' do
      let!(:user3){ create(:user) }

      it 'should return votable total score' do
        question.votes.create(user: user, value: -1)
        question.votes.create(user: user3, value: -1)

        expect(question.total_score).to eq -2
      end
    end
  end

end
