require 'rails_helper'

RSpec.describe MailMessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:mail_message) { create(:mail_message) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show, id: mail_message.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, id: mail_message.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create, mail_message: {
        label: 'label_t', subject: 'test', body: 'btest' }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'PUT #update' do
    it 'returns http success' do
      put :update, id: mail_message.id, mail_message: { label: 'foo' }
      expect(response).to have_http_status(:redirect)
    end
  end
end
