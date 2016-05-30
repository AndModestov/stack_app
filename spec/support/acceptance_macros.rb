module AcceptanceMacros
  def log_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def mock_auth_hash(hash = {})
    hash = {provider: 'facebook', uid: '123456', info: {email: 'provider@example.com'}}.merge(hash)
    OmniAuth.config.mock_auth[hash[:provider].to_sym] = OmniAuth::AuthHash.new(hash)
  end
end