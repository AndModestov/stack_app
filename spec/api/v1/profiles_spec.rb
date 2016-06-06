require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me){ create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "dont contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access_token is invalid' do
        get '/api/v1/profiles', format: :json, access_token: '123456'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:all){ create_list(:user, 2) }
      let(:me){ create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains other profiles' do
        all.each do |profile|
          expect(response.body).to include_json(profile.to_json)
        end
      end

      it 'dont contains signed in user' do
        expect(response.body).to_not include_json(me.to_json)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          all.each do |profile|
            expect(response.body).to be_json_eql(profile.send(attr.to_sym).to_json)
                                         .at_path("#{all.index(profile)}/#{attr}")
          end
        end
      end

      %w(password encrypted_password).each do |attr|
        it "dont contains #{attr}" do
          all.each do |profile|
            expect(response.body).to_not have_json_path("#{all.index(profile)}/#{attr}")
          end
        end
      end
    end
  end
end