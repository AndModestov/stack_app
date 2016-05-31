require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe 'get #new' do
    before do
      session['devise.oauth_data'] = {provider: 'twitter', uid: '123456'}
      get :new
    end

    it { should render_template :new }
  end

  describe 'post #create' do
    before do
      session['devise.oauth_data'] = {provider: 'twitter', uid: '123456'}
    end
    context 'with valid data' do
      it 'assigns user to User' do
        post :create, email: 'user@email.com'
        expect(assigns(:user)).to be_a(User)
      end

      it 'redirects to root_path' do
        post :create, email: 'user@email.com'
        expect(response).to redirect_to root_path
      end
    end

    it 'redirects to authorization page if user not present' do
      post :create, email: nil
      expect(response).to redirect_to new_user_registration_path
    end
  end
end
