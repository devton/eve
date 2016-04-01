require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'returns http success' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns http redirect when not authenticated' do
      get :index
      expect(response).to have_http_status(:redirect)
    end
  end
end
