class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    oauth
  end

  def vkontakte
    oauth
  end

  def twitter
    oauth
  end

  private

  def oauth
    auth_hash = request.env['omniauth.auth']
    provider = request.env['omniauth.auth'][:provider].to_s
    @user = User.find_for_oauth(auth_hash)

    if @user.persisted?
      auth = @user.authorizations.find_by(provider: provider)
      check_authorization(auth)
    else
      session["devise.oauth_data"] = {provider: auth_hash.provider, uid: auth_hash.uid}
      redirect_to new_authorization_path
    end
  end

  def check_authorization(auth)
    if auth.confirmed?
      sign_in_and_redirect auth.user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
    else
      redirect_to new_user_registration_path
      flash[:notice] = "Please confirm your authorization by email."
      session["devise.user"] = {user_id: auth.user_id}
    end
  end
end