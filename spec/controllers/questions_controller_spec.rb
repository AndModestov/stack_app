require 'rails_helper'

describe QuestionsController do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:wrong_user){ create(:user) }
  let(:wrong_question){ create(:question, user: wrong_user) }

  describe 'GET #index' do
    let(:questions){ create_list(:question, 2) }
    before { get :index}

    it 'assigns a @questions list' do
      expect(assigns(:questions)).to eq questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new @answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new answers attachment' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'should render the show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new questions attachment' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'should render the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid information' do
      it 'saves the question in database' do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid information' do
      it 'does not save the question' do
        expect {
          post :create, question: attributes_for(:invalid_question)
        }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do

    context 'update current users question' do
      it 'assigns question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'updates question attributes' do
        patch :update, id: question, question: { title: 'updated title', body: 'updated body' }, format: :js
        question.reload
        expect(question.title).to eq 'updated title'
        expect(question.body).to eq 'updated body'
      end

      it 'renders template update' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'update other users question' do
      it 'dont updates question attributes' do
        patch :update, id: wrong_question, question: { title: 'updated title', body: 'updated body' }, format: :js
        wrong_question.reload
        expect(wrong_question.title).to_not eq 'updated title'
        expect(wrong_question.body).to_not eq 'updated body'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'delete current users question' do
      it 'deletes question' do
        question
        expect{
          delete :destroy, id: question
        }.to change(@user.questions, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'delete other users question' do
      it 'dont deletes question' do
        wrong_question
        expect{
          delete :destroy, id: wrong_question
        }.to_not change(Question, :count)
      end

      it 'redirect to login view' do
        delete :destroy, id: wrong_question
        expect(response).to redirect_to wrong_question
      end
    end
  end


  describe 'PATCH #vote_up' do
    context 'vote_up for other users question' do
      it 'assigns question to @question' do
        patch :vote_up, id: wrong_question, format: :json
        expect(assigns(:votable)).to eq wrong_question
      end

      it 'votes up for question' do
        expect{ patch :vote_up, id: wrong_question, format: :json }.to change(wrong_question.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_up, id: wrong_question, format: :json
        expect{ patch :vote_up, id: wrong_question, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_up for own question' do
      it 'dont votes up for question' do
        expect{ patch :vote_up, id: question, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'vote_down for other users question' do
      it 'assigns question to @question' do
        patch :vote_down, id: wrong_question, format: :json
        expect(assigns(:votable)).to eq wrong_question
      end

      it 'votes down for question' do
        expect{ patch :vote_down, id: wrong_question, format: :json }.to change(wrong_question.votes, :count).by(1)
      end

      it 'dont votes up twice' do
        patch :vote_down, id: wrong_question, format: :json
        expect{ patch :vote_down, id: wrong_question, format: :json }.to_not change(Vote, :count)
      end
    end

    context 'vote_down for own question' do
      it 'dont votes up for question' do
        expect{ patch :vote_down, id: question, format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #delete_vote' do
    context 'deletes vote' do
      it 'assigns question to @question' do
        patch :delete_vote, id: wrong_question, format: :json
        expect(assigns(:votable)).to eq wrong_question
      end

      it 'deletes existed vote for question' do
        patch :vote_up, id: wrong_question, format: :json
        expect{ patch :delete_vote, id: wrong_question, format: :json }.to change(wrong_question.votes, :count).by(-1)
      end
    end
  end
end
