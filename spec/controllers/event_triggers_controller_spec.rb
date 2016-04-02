require 'rails_helper'

RSpec.describe EventTriggersController, type: :controller do
  let(:user) { create(:user) }
  let(:event_trigger) { create(:event_trigger) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, id: event_trigger.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, id: event_trigger.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, event_trigger: {
        trigger_name: 'tr_name',
        description: 'tr_description'
      }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET #update' do
    it 'returns http success' do
      get :update, id: event_trigger.id, event_trigger: {
        description: 'tr_desc'
      }
      expect(response).to have_http_status(:redirect)
    end
  end
end
