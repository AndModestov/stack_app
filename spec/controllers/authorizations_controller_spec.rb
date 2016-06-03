require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do

  describe 'GET #new' do
    before do
      session['devise.oauth_data'] = {provider: 'twitter', uid: '123456'}
      get :new
    end

    it { should render_template :new }
  end

  describe 'POST #create' do
    before do
      session['devise.oauth_data'] = {provider: 'twitter', uid: '123456'}
    end

    context 'with existing user' do
      let(:user){ create(:user) }

      it 'assigns user to @user' do
        post :create, email: user.email
        expect(assigns(:user)).to eq user
      end

      it 'assigns authorization to @auth' do
        post :create, email: user.email
        expect(assigns(:auth)).to be_a(Auth)
      end
    end

    it 'redirects to authorization page if user not present' do
      post :create, email: nil
      expect(response).to redirect_to new_user_registration_path
    end
  end

  describe 'GET #confirm_auth' do
    let(:user){ create(:user) }
    let!(:auth){ create(:authorization, user: user, token: '1234567890') }

    context 'with valid token' do
      before do
        get :confirm_auth, token: '1234567890'
      end

      it 'assigns auth to @auth' do
        expect(assigns(:auth)).to eq auth
      end

      it 'confirms authorization' do
        auth.reload
        expect(auth.confirmed).to be true
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it { should be_user_signed_in }
    end

    context 'with invalid token' do
      before do
        get :confirm_auth, token: '543210'
      end

      it 'dont confirms authorization' do
        expect(auth.confirmed).to be false
      end

      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
