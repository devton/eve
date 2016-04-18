require 'rails_helper'

RSpec.describe Api::IncomingEventsController, type: :controller do
  let(:event_trigger) { create(:event_trigger) }
  let(:mail_action) do
    create(
      :event_trigger_mail_action,
      event_trigger: event_trigger
    )
  end
  let(:event_body) do
    {
      event_name: event_trigger.trigger_name,
      session_id: '1234',
      email: 'test@test.com',
      user: { name: 'foo' }
    }
  end
  let(:post_body) do
    {
      key: api_key.key,
      event_hash: api_key.encode_message(event_body.to_json)
    }
  end

  let(:api_key) { ApiKey.generate! }

  describe 'POST #create' do
    it 'returns http success when pass valid params' do
      post :create, post_body, format: :json
      expect(response).to have_http_status(:created)
    end

    it 'returns http not_found when pass invalid trigger name' do
      event_body.update(event_name: 'invalid')
      post :create, post_body, format: :json
      expect(response).to have_http_status(:not_found)
    end

    it 'returns http bad_request when invalid key' do
      post_body.update(key: 'lorem')
      post :create, post_body, format: :json
      expect(response).to have_http_status(:bad_request)
    end

    it 'return http bad_request when invalid hash' do
      post_body.update(event_hash: 'loremameonri')
      post :create, post_body, format: :json
      expect(response).to have_http_status(:bad_request)
    end


    it 'returns http bad_request when missing some required attribute' do
      event_body.delete(:session_id)
      post :create, post_body, format: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
