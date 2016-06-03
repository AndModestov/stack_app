require 'rails_helper'

feature 'Omniauth' do
  given(:user) { create(:user) }

  describe 'facebook' do
    it 'sign up new user' do
      visit new_user_registration_path
      mock_auth_hash
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from facebook account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(info: {email: user.email})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Please confirm your authorization by email.'

      open_email(user.email)
      current_email.click_on 'confirm'

      expect(page).to have_content 'Successfully authenticated from facebook account.'
    end

    it 'login user with confirmed authorization' do
      user.authorizations.create(provider: 'facebook', uid: '123456', confirmed: true)
      visit new_user_registration_path
      mock_auth_hash(info: {email: user.email})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from facebook account.'
    end

    it 'dont login user with unconfirmed authorization' do
      user.authorizations.create(provider: 'facebook', uid: '123456', confirmed: false)
      visit new_user_registration_path
      mock_auth_hash(info: {email: user.email})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Please confirm your authorization by email.'
    end

    it 'handle authentication error' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit new_user_registration_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
    end
  end

  describe 'vkontakte' do
    it 'sign up new user' do
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte')
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte', info: {email: user.email})
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please confirm your authorization by email.'

      open_email(user.email)
      current_email.click_on 'confirm'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    it 'login user with confirmed authorization' do
      user.authorizations.create(provider: 'vkontakte', uid: '123456', confirmed: true)
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte', info: {email: user.email})
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    end

    it 'dont login user with unconfirmed authorization' do
      user.authorizations.create(provider: 'vkontakte', uid: '123456', confirmed: false)
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte', info: {email: user.email})
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Please confirm your authorization by email.'
    end

    it 'handle authentication error' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_registration_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Could not authenticate you from Vkontakte because "Invalid credentials"'
    end
  end

  describe 'twitter' do
    it 'sign up new user' do
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      fill_in 'Email:', with: 'newuser@email.com'
      click_on 'Submit'

      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      fill_in 'Email:', with: user.email
      click_on 'Submit'

      expect(page).to have_content 'Email sent. Please confirm your authorization.'

      open_email(user.email)
      current_email.click_on 'confirm'

      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    it 'login user with confirmed authorization' do
      user.authorizations.create(provider: 'twitter', uid: '123456', confirmed: true)
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end

    it 'dont login user with unconfirmed authorization' do
      user.authorizations.create(provider: 'twitter', uid: '123456', confirmed: false)
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Please confirm your authorization by email.'
    end

    it 'handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit new_user_registration_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
    end
  end

  describe 'resend confirmation email' do
    it 'sends again email' do
      user.authorizations.create(provider: 'twitter', uid: '123456', token: 'newtoken', confirmed: false)
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'
      click_on 'Resend confirmation?'

      expect(page).to have_content 'Email sent. Please confirm your authorization.'
      open_email(user.email)
      current_email.click_on 'confirm'
      expect(page).to have_content 'Successfully authenticated from twitter account.'
    end
  end
end