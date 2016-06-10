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
    context 'creating a new user with confirmed auth' do
      before do
        post :create, { email: 'test@email.com' },
                      { 'devise.oauth_data' => {'provider' => 'twitter', 'uid' => '123456'} }
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end

      it 'assigns auth to @auth' do
        expect(assigns(:auth)).to be_a(Authorization)
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to root_path
      end

      it { should be_user_signed_in }
    end

    context 'creating new authorization for existing user' do
      let(:user){ create(:user) }
      before do
        post :create, { email: user.email },
                      { 'devise.oauth_data' => {'provider' => 'twitter', 'uid' => '123456'} }
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end

      it 'assigns auth to @auth' do
        expect(assigns(:auth)).to eq user.authorizations.first
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to new_user_registration_path
      end

      it { should_not be_user_signed_in }
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

  describe 'GET #resend_confirmation_email' do
    let!(:user){ create(:user) }
    let!(:authorization){ create(:authorization, user: user, token: '123456', confirmed: false) }

    it 'sends confirmation email' do
      message = double(ConfirmOauth.email_confirmation(user))
      allow(ConfirmOauth).to receive(:email_confirmation).with(user).and_return(message)
      expect(message).to receive(:deliver_now)
      get :resend_confirmation_email, {}, {'devise.user' => {'user_id' => user.id}}
    end

    it 'redirects to registration_path' do
      get :resend_confirmation_email, {}, {'devise.user' => {'user_id' => user.id}}

      expect(response).to redirect_to new_user_registration_path
    end
  end
end
