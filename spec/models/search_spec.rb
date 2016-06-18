require 'rails_helper'

RSpec.describe Search, type: :sphinx do

  describe 'request method' do
    it 'returns right objects' do
      user = create(:user)
      question = create(:question, user: user)
      answer = create(:answer, question: question, user: user)
      comment = create(:comment, commentable: question, user: user)
      index

      expect(Search.request('', 'all')).to match_array [user, question, answer, comment]
      expect(Search.request(question.title, 'questions')).to match_array [question]
      expect(Search.request(answer.body, 'answers')).to match_array [answer]
      expect(Search.request(comment.body, 'comments')).to match_array [comment]
      expect(Search.request(user.email, 'users')).to match_array [user]
    end

    it 'returns empty arr if context is invalid' do
      user = create(:user)
      create(:question, user: user)
      index

      expect(Search.request('', 'invalid')).to match_array []
    end
  end
end
