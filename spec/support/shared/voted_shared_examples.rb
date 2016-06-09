require 'rails_helper'

shared_examples "voted" do

  describe 'PATCH #vote_up' do
    context 'vote_up for other users votable' do
      it 'assigns votable to @votable' do
        patch :vote_up, id: votable, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'votes up for votable' do
        expect{ patch :vote_up, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_up, id: votable, format: :json
        expect{ patch :vote_up, id: votable, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_up for own votable' do
      it 'dont votes up for votable' do
        expect{ patch :vote_up, id: own_votable, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'vote_down for other users votable' do
      it 'assigns votable to @votable' do
        patch :vote_down, id: votable, format: :json
        expect(assigns(:votable)).to eq votable
      end

      it 'votes down for votable' do
        expect{ patch :vote_down, id: votable, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_down, id: votable, format: :json
        expect{ patch :vote_down, id: votable, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_down for own votable' do
      it 'dont votes up for votable' do
        expect{ patch :vote_down, id: own_votable, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #delete_vote' do
    it 'assigns votable to @votable' do
      patch :delete_vote, id: votable, format: :json
      expect(assigns(:votable)).to eq votable
    end

    it 'deletes existed vote for votable' do
      patch :vote_up, id: votable, format: :json
      expect{ patch :delete_vote, id: votable, format: :json }.to change(votable.votes, :count).by(-1)
    end
  end
end