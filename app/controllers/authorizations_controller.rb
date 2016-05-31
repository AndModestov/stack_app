class AuthorizationsController < ApplicationController
  def new
  end

  def create
    provider = session['devise.oauth_data']['provider']
    uid = session['devise.oauth_data']['uid']
    email = params[:email]
    auth = OmniAuth::AuthHash.new({ provider: provider, uid: uid, info: {email: email} })
    @user = User.find_for_oauth(auth) unless email.blank?
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{provider.to_s} account."
    else
      redirect_to new_user_registration_path
      flash[:notice] = "Could not authenticate you from #{provider.to_s} account."
    end
  end
end
