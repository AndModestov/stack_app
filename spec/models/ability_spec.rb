require 'rails_helper'

describe Ability do
  subject(:ability){ Ability.new(user) }

  describe 'for guest' do
    let(:user){ nil }

    it { should be_able_to :read, Question }
    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user){ create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let(:answer){ create(:answer, question: question, user: user) }
    let(:other_user){ create(:user) }
    let(:other_question){ create(:question, user: other_user) }
    let(:other_answer){ create(:answer, question: other_question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }

    it { should be_able_to :make_best, answer }
    it { should_not be_able_to :make_best, other_answer}

    it { should be_able_to :vote_up, other_question }
    it { should be_able_to :vote_down, other_question }
    it { should be_able_to :delete_vote, other_question }
    it { should be_able_to :vote_up, other_answer }
    it { should be_able_to :vote_down, other_answer }
    it { should be_able_to :delete_vote, other_answer }
    it { should_not be_able_to :vote_up, question }
    it { should_not be_able_to :vote_down, question }
    it { should_not be_able_to :delete_vote, question }
    it { should_not be_able_to :vote_up, answer }
    it { should_not be_able_to :vote_down, answer }
    it { should_not be_able_to :delete_vote, answer }
  end
end