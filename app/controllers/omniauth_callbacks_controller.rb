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
    auth = request.env['omniauth.auth']
    provider = request.env['omniauth.auth'][:provider].to_s
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.oauth_data"] = {provider: auth.provider, uid: auth.uid}
      redirect_to new_authorization_path
    end
  end
end