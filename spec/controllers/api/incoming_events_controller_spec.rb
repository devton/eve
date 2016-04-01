require 'rails_helper'

RSpec.describe Api::IncomingEventsController, type: :controller do
  let(:event_trigger) { create(:event_trigger) }
  let(:mail_action) { create(:event_trigger_mail_action, event_trigger: event_trigger) }
  let(:post_body) do
    {
      trigger_name: event_trigger.trigger_name,
      to: 'test@test.com',
      subject_data: {
        user: { name: 'foo' }
      },
      body_data: {
        user: { name: 'foo body' }
      }
    }
  end

  describe "POST #create" do
      it "returns http success when pass valid params" do
        post :create, event: post_body, format: :json
        expect(response).to have_http_status(:created)
      end

      it "returns http not_found when pass invalid trigger name" do
        post :create, event: post_body.update(trigger_name: 'invalid'), format: :json
        expect(response).to have_http_status(:not_found)
      end

      it "returns http bad_request when missing some required attribute" do
        post_body.delete(:to)
        post :create, event: post_body, format: :json
        expect(response).to have_http_status(:bad_request)
      end
  end
end
