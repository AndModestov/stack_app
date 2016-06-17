require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }
  it { should validate_presence_of :body }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }

  describe 'commentable_path_id method' do
    let(:question){ create(:question) }
    let(:other_question){ create(:question) }
    let(:answer){ create(:answer, question: other_question) }
    let(:comment1){ create(:comment, commentable: question) }
    let(:comment2){ create(:comment, commentable: answer) }

    it 'returns question_id if comentable is question' do
      expect(comment1.commentable_path_id).to eq question.id
    end

    it 'returns answers question_id if comentable is answer' do
      expect(comment2.commentable_path_id).to eq other_question.id
    end
  end
end
