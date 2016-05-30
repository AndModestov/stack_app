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

    it 'builds omniauth hash' do
      post :create, params: { email: 'user@email.com' }
      expect(assigns(:auth)).to be_a(OmniAuth::AuthHash)
    end

    it 'assigns user to User' do
      post :create, params: { email: 'user@email.com' }
      expect(assigns(:user)).to be_a(User)
    end

    it 'redirects to twitter_omniauth_authorize_path' do
      post :create, params: { email: 'user@email.com' }
      expect(response).to redirect_to user_twitter_omniauth_authorize_path
    end
  end

end
