require 'rails_helper'

feature 'Omniauth' do
  given(:user) { create(:user) }

  describe 'facebook' do
    it 'sign up new user' do
      visit new_user_registration_path
      mock_auth_hash
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(info: {email: user.email})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    it 'login user with existing authorization' do
      user.authorizations.create(provider: 'facebook', uid: '123456')
      visit new_user_registration_path
      mock_auth_hash(info: {email: user.email})
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
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

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte', info: {email: user.email})
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    it 'login user with existing authorization' do
      user.authorizations.create(provider: 'vkontakte', uid: '123456')
      visit new_user_registration_path
      mock_auth_hash(provider: 'vkontakte', info: {email: user.email})
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
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

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    it 'add authorization to existing user' do
      user
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      fill_in 'Email:', with: user.email
      click_on 'Submit'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    it 'login user with existing authorization' do
      user.authorizations.create(provider: 'twitter', uid: '123456')
      visit new_user_registration_path
      mock_auth_hash(provider: 'twitter', info: nil)
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end

    it 'handle authentication error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      visit new_user_registration_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
    end
  end

end