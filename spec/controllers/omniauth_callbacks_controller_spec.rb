require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #facebook' do
    it_behaves_like "Omniauthable" do
      let(:provider){ 'facebook' }
    end
  end


  describe 'GET #vkontakte' do
    it_behaves_like "Omniauthable" do
      let(:provider){ 'vkontakte' }
    end
  end


  describe 'GET #twitter' do
    it_behaves_like "Omniauthable" do
      let(:provider){ 'twitter' }
    end
  end
end