shared_examples_for "votable" do
  describe 'voted_by?' do
    it 'should return true if votable is voted by user' do
      votable.votes.create(user: user, value: 1)
      expect(votable).to be_voted_by(user)
    end

    it 'should return false if votable is voted by user' do
      expect(votable).to_not be_voted_by(user)
    end
  end

  describe 'vote_up' do
    it 'should add + vote to votable' do
      expect{ votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to be(1)
    end

    it 'shouldnt add + vote to voted votable' do
      votable.votes.create(user: user, value: 1)

      expect{ votable.vote_up(user) }.to_not change(votable.votes, :count)
    end
  end

  describe 'vote_down' do
    it 'should add - vote to votable' do
      expect{ votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to be(-1)
    end

    it 'shouldnt add + vote to voted votable' do
      votable.votes.create(user: user, value: -1)

      expect{ votable.vote_down(user) }.to_not change(votable.votes, :count)
    end
  end

  describe 'delete_vote' do
    it 'should delete users vote' do
      votable.votes.create(user: user, value: 1)

      expect{ votable.delete_vote(user) }.to change(votable.votes, :count).by(-1)
      expect(Vote.count).to be 0
    end
  end

  describe 'total_score' do
    let!(:user3){ create(:user) }

    it 'should return votable total score' do
      votable.votes.create(user: user, value: -1)
      votable.votes.create(user: user3, value: -1)

      expect(votable.total_score).to eq -2
    end
  end
end