require 'rails_helper'

describe AnswersController do
  let(:question) { create(:question) }

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
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid information' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end
end
