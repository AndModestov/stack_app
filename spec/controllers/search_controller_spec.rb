require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    it 'calls request method' do
      expect(Search).to receive(:request).with('', 'all')
      get :index, search_content: '', search_context: 'all'
    end

    it 'renders template index' do
      get :index, search_content: '', search_context: 'all'
      expect(response).to render_template 'index'
    end
  end
end
