require 'rails_helper'

describe AnswersController do
  sign_in_user
  let(:question){ create(:question, user: @user) }
  let(:answer){ create(:answer, user: @user, question: question) }

  describe 'GET #new' do
    before { get :new, question_id: question }

    it 'assigns a new answer to @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'should render the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid information' do
      it 'saves the answer in database' do
        expect {
          post :create, question_id: question, answer: attributes_for(:answer)
        }.to change(question.answers, :count).by(1) && change(@user.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid information' do
      it 'does not save the answer' do
        expect {
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
        }.to_not change(Answer, :count)
      end

      it 're-renders new answer view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'delete current users answer' do
      it 'deletes answer' do
        answer
        expect{ delete :destroy, question_id: question, id: answer }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, question_id: question, id: answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'delete other users answer' do
      let(:wrong_user){ create(:user) }
      let(:wrong_answer){ create(:answer, question: question, user: wrong_user) }

      it 'dont deletes question' do
        wrong_answer
        expect{ delete :destroy, question_id: question, id: wrong_answer }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, question_id: question, id: wrong_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
