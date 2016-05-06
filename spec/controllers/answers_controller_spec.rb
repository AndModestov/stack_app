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
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns question to @question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, answer: { body: 'new body' }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end

    context 'update other users answer' do
      it 'not changes answer attributes' do
        patch :update, id: wrong_answer, question_id: question, answer: { body: 'new body' }, format: :js
        wrong_answer.reload
        expect(wrong_answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'delete current users answer' do
      it 'deletes answer' do
        expect{ delete :destroy, question_id: question, id: answer }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'delete other users answer' do
      it 'dont deletes question' do
        expect{ delete :destroy, question_id: question, id: wrong_answer }.to_not change(Answer, :count)
      end

      it 'redirect to log in view' do
        delete :destroy, question_id: question, id: wrong_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
