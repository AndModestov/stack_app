class AuthorizationsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    provider = session['devise.oauth_data']['provider']
    uid = session['devise.oauth_data']['uid']
    email = params[:email]
    auth_hash = OmniAuth::AuthHash.new({ provider: provider, uid: uid, info: {email: email} })

    @user = User.find_for_oauth(auth_hash) unless email.blank?
    @auth = @user.authorizations.find_by(provider: provider)
    authenticate_if_confirmed(@auth)
  end

  def confirm_auth
    @auth = Authorization.find_by(token: (params[:token]))
    confirm_authorization(@auth)
  end

  def resend_confirmation_email
    user = User.find(session["devise.user"]["user_id"])
    ConfirmOauth.email_confirmation(user).deliver_later
    email_sent_message
  end

  private

  def confirm_authorization(auth)
    if auth
      auth.confirm!
      log_in(auth)
    else
      redirect_to new_user_registration_path
      flash[:notice] = "Failed. Invalid Authorization token"
    end
  end

  def authenticate_if_confirmed(auth)
    if auth.confirmed?
      log_in(auth)
    else
      email_sent_message
    end
  end

  def email_sent_message
    redirect_to new_user_registration_path
    flash[:notice] = "Email sent. Please confirm your authorization."
  end

  def log_in(auth)
    sign_in_and_redirect auth.user, event: :authentication
    flash[:notice] = "Successfully authenticated from #{auth.provider.to_s} account."
  end
end
