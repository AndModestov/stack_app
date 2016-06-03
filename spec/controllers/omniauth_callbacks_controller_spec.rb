require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    context 'user dont exist yet' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'facebook',
                                                               uid: '123456',
                                                               info: {email: 'new-user@email.com'}})
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
      it { should be_user_signed_in }
    end

    context 'found user without authorization' do
      before do
        user
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'facebook',
                                                               uid: '123456',
                                                               info: {email: user.email}})
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it 'builds user data for resending confirmation' do
        expect(session['devise.user'][:user_id]).to eq user.id
      end
      it { should_not be_user_signed_in }
    end

    context 'found user with confirmed authorization' do
      let(:auth){ create(:authorization, user: user, confirmed: true) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it { should be_user_signed_in }
    end

    context 'found user with unconfirmed authorization' do
      let(:auth){ create(:authorization, user: user, confirmed: false) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :facebook
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it { should_not be_user_signed_in }
    end
  end


  describe 'GET #vkontakte' do
    context 'user dont exist yet' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'vkontakte',
                                                               uid: '123456',
                                                               info: {email: 'new-user@email.com'}})
        get :vkontakte
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
      it { should be_user_signed_in }
    end

    context 'found user without authorization' do
      before do
        user
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'vkontakte',
                                                               uid: '123456',
                                                               info: {email: user.email}})
        get :vkontakte
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it 'builds user data for resending confirmation' do
        expect(session['devise.user'][:user_id]).to eq user.id
      end
      it { should_not be_user_signed_in }
    end

    context 'found user with confirmed authorization' do
      let(:auth){ create(:authorization, provider: 'vkontakte', user: user, confirmed: true) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :vkontakte
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it { should be_user_signed_in }
    end

    context 'found user with unconfirmed authorization' do
      let(:auth){ create(:authorization, provider: 'vkontakte', user: user, confirmed: false) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :vkontakte
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it { should_not be_user_signed_in }
    end
  end


  describe 'GET #twitter' do
    context 'email not returned' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'twitter',
                                                               uid: '123456',
                                                               info: {email: nil}})
        get :twitter
      end

      it 'stores data in session' do
        expect(session['devise.oauth_data'][:provider]).to eq 'twitter'
        expect(session['devise.oauth_data'][:uid]).to eq '123456'
      end
      it { should_not be_user_signed_in }
      it { should redirect_to new_authorization_path }
    end

    context 'user dont exist yet' do
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'twitter',
                                                               uid: '123456',
                                                               info: {email: 'new-user@email.com'}})
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to be_a(User)
      end
      it { should be_user_signed_in }
    end

    context 'found user without authorization' do
      before do
        user
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: 'vkontakte',
                                                               uid: '123456',
                                                               info: {email: user.email}})
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it { should_not be_user_signed_in }
    end

    context 'found user with confirmed authorization' do
      let(:auth){ create(:authorization, provider: 'twitter', user: user, confirmed: true) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it { should be_user_signed_in }
    end

    context 'found user with unconfirmed authorization' do
      let(:auth){ create(:authorization, provider: 'twitter', user: user, confirmed: false) }
      before do
        request.env["omniauth.auth"] = OmniAuth::AuthHash.new({provider: auth.provider,
                                                               uid: auth.uid,
                                                               info: {email: user.email}})
        get :twitter
      end

      it 'assigns user to @user' do
        expect(assigns(:user)).to eq user
      end
      it 'redirects to sign_up path' do
        expect(response).to redirect_to new_user_registration_path
      end
      it { should_not be_user_signed_in }
    end
  end
end