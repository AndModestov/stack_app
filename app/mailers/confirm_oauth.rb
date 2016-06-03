class ConfirmOauth < ApplicationMailer
  default from: "security@stackapp.com"

  def email_confirmation(user)
    @user = user
    auth = @user.authorizations.last
    @url = confirm_auth_url(token: auth.token)
    mail(to: @user.email, subject: 'StackApp. Please confirm authorization')
  end
end
