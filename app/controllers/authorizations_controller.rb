class AuthorizationsController < ApplicationController
  def new
  end

  def create
    provider = session['devise.oauth_data']['provider']
    uid = session['devise.oauth_data']['uid']
    email = params[:email]
    @auth = OmniAuth::AuthHash.new({ provider: provider, uid: uid, info: {email: email} })
    @user = User.find_for_oauth(@auth)
    redirect_to user_twitter_omniauth_authorize_path
  end
end
