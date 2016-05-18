require 'rails_helper'

describe AnswersController do
  sign_in_user
  let!(:question){ create(:question, user: @user) }
  let!(:answer){ create(:answer, user: @user, question: question) }
  let(:wrong_user){ create(:user) }
  let!(:wrong_answer){ create(:answer, question: question, user: wrong_user) }

  describe 'POST #create' do

    context 'with valid information' do
      it 'saves the answer in database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1) && change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid information' do
      it 'does not save the answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 're-renders question view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do

    context 'update current users answer' do
      it 'assigns answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'update other users answer' do
      it 'not changes answer attributes' do
        patch :update, id: wrong_answer, answer: { body: 'new body' }, format: :js
        wrong_answer.reload
        expect(wrong_answer.body).to_not eq 'new body'
      end

      it 'redirect to sign in path' do
        patch :update, id: wrong_answer, answer: { body: 'new body' }, format: :js
        expect(response).to redirect_to answer.question
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'delete current users answer' do
      it 'deletes answer' do
        expect{
          delete :destroy, id: answer, format: :js
        }.to change(question.answers, :count).by(-1)
      end

      it 'render question view' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'delete other users answer' do
      it 'dont deletes answer' do
        expect{
          delete :destroy, id: wrong_answer, format: :js
        }.to_not change(Answer, :count)
      end

      it 'redirect to sign in path' do
        delete :destroy, id: wrong_answer, format: :js
        expect(response).to redirect_to wrong_answer.question
      end
    end
  end

  describe 'PATCH #make_best' do

    context 'question author chose best answer' do
      it 'assigns answer to @answer' do
        patch :make_best, id: answer
        expect(assigns(:answer)).to eq answer
      end

      it 'redirects to question' do
        patch :make_best, id: answer
        expect(response).to redirect_to question
      end

      it 'makes answer the best' do
        patch :make_best, id: answer
        answer.reload
        expect(answer.best).to be true
      end
    end

    context 'other user try to chose best answer' do
      let(:wrong_question){ create(:question, user: wrong_user) }
      let!(:wrong_question_answer){ create(:answer, question: wrong_question, user: wrong_user) }

      it 'cant chose best answer' do
        patch :make_best, id: wrong_question_answer
        wrong_question_answer.reload
        expect(wrong_question_answer.best).to be false
      end
    end
  end


  describe 'PATCH #vote_up' do
    context 'vote_up for other users answer' do
      it 'assigns answer to @answer' do
        patch :vote_up, id: wrong_answer, format: :json
        expect(assigns(:votable)).to eq wrong_answer
      end

      it 'votes up for answer' do
        expect{ patch :vote_up, id: wrong_answer, format: :json }.to change(wrong_answer.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_up, id: wrong_answer, format: :json
        expect{ patch :vote_up, id: wrong_answer, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_up for own answer' do
      it 'dont votes up for answer' do
        expect{ patch :vote_up, id: answer, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'vote_down for other users answer' do
      it 'assigns answer to @answer' do
        patch :vote_down, id: wrong_answer, format: :json
        expect(assigns(:votable)).to eq wrong_answer
      end

      it 'votes down for answer' do
        expect{ patch :vote_down, id: wrong_answer, format: :json }.to change(wrong_answer.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_down, id: wrong_answer, format: :json
        expect{ patch :vote_down, id: wrong_answer, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_down for own answer' do
      it 'dont votes up for answer' do
        expect{ patch :vote_down, id: answer, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #delete_vote' do
    context 'deletes vote' do
      it 'assigns answer to @answer' do
        patch :delete_vote, id: wrong_answer, format: :json
        expect(assigns(:votable)).to eq wrong_answer
      end

      it 'deletes existed vote for answer' do
        patch :vote_up, id: wrong_answer, format: :json
        expect{ patch :delete_vote, id: wrong_answer, format: :json }.to change(wrong_answer.votes, :count).by(-1)
      end
    end
  end
end
