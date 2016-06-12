require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers) }

  it { should have_many(:votes) }

  it { should have_many(:comments) }

  it { should have_many(:authorizations).dependent(:destroy) }

  describe 'author_of? method' do
    let(:user){ create(:user) }
    let(:question){ create(:question, user: user) }
    let(:user2){ create(:user) }
    let(:question2){ create(:question, user: user2) }

    it 'should return true when User is author of question/answer' do
      expect(user).to be_author_of(question)
    end

    it 'should return false when User is not author of question/answer' do
      expect(user).to_not be_author_of(question2)
    end
  end

  describe '.find_for_oauth' do
    let!(:user){ create(:user) }
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: user.email}) }
        it 'does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with right data' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
          expect(authorization.confirmed).to eq false
        end

        it 'sends confirmation email' do
          message = double(ConfirmOauth.email_confirmation(user))
          allow(ConfirmOauth).to receive(:email_confirmation).with(user).and_return(message)
          expect(message).to receive(:deliver_later)
          User.find_for_oauth(auth)
        end

        it 'should return user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with right data' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
          expect(authorization.confirmed).to eq true
        end
      end
    end
  end
end