require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let(:other_user){ create(:user) }
  let(:question){ create(:question, user: other_user) }

  describe 'POST #create' do
    it 'creates new subscription' do
      expect{ post :create, question_id: question.id, format: :json }.to change(@user.subscriptions, :count).by(1) &&
                                                                         change(question.subscriptions, :count).by(1)
    end

    it 'does not creates subscription twice' do
      create(:subscription, question_sub_id: question.id, sub_user_id: @user.id)
      expect{ post :create, question_id: question.id, format: :json }.to_not change(Subscription, :count)
    end

    it 'assigns question to @question' do
      post :create, question_id: question.id, format: :json
      expect(assigns(:question)).to eq question
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes existing subscription' do
      create(:subscription, question_sub_id: question.id, sub_user_id: @user.id)
      expect{ delete :destroy, question_id: question.id, format: :json }.to change(@user.subscriptions, :count).by(-1) &&
                                                                            change(question.subscriptions, :count).by(-1)
    end

    it 'assigns question to @question' do
      post :create, question_id: question.id, format: :json
      expect(assigns(:question)).to eq question
    end
  end
end
