require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:question){ create(:question, user: @user) }
  let!(:answer){ create(:answer, user: @user, question: question) }

  describe 'POST #create' do

    context 'with valid information' do
      it 'assigns question to @commentable' do
        post :create, commentable: 'questions', question_id: question,
                                                comment: attributes_for(:comment), format: :js
        expect(assigns(:commentable)).to eq question
      end

      it 'saves the question comment in database' do
        expect {
          post :create, commentable: 'questions', question_id: question,
                                                  comment: attributes_for(:comment), format: :js
        }.to change(question.comments, :count).by(1) && change(@user.comments, :count).by(1)
      end

      it 'assigns answer to @commentable' do
        post :create, commentable: 'answers', answer_id: answer,
                                              comment: attributes_for(:comment), format: :js
        expect(assigns(:commentable)).to eq answer
      end

      it 'saves the answer comment in database' do
        expect {
          post :create, commentable: 'answers', answer_id: answer,
                                                comment: attributes_for(:comment), format: :js
        }.to change(answer.comments, :count).by(1) && change(@user.comments, :count).by(1)
      end

      it 'publish comment to /comments' do
        expect(PrivatePub).to receive(:publish_to).with("/comments", anything)
        post :create, commentable: 'answers', answer_id: answer,
             comment: attributes_for(:comment), format: :js
      end
    end

    context 'with invalid information' do
      it 'does not save the answer' do
        expect {
          post :create, commentable: 'questions', question_id: question,
                                                  comment: attributes_for(:invalid_comment), format: :json
        }.to_not change(Comment, :count)
      end

      it 'does not publish comment to /comments' do
        expect(PrivatePub).to_not receive(:publish_to).with("/comments", anything)
        post :create, commentable: 'questions', question_id: question,
              comment: attributes_for(:invalid_comment), format: :js
      end
    end
  end
end
