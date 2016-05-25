require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe "POST to Events controller, create action" do
    it "returns http success" do
      post :create, {value: 20, capture_time: Time.now, notified: false, sensor_id: 1, api_key: "AANR71J65VHMH5WZ26A1K4"}
      # expect(response).to have_http_status(:success)
      expect(response).to be_success
    end

    it "returns non-NIL status in JSON" do
      post :create, {value: 20, capture_time: Time.now, notified: false, sensor_id: 1, api_key: "AANR71J65VHMH5WZ26A1K4"}
      expect(response.body).to_not be_nil
    end
    #
    # it "returns status of unauthorized in JSON" do
    #   post :create, {value: 20, capture_time: Time.now, notified: false, sensor_id: 1, api_key: "AANR71J65VHMH5WZ26A1K4"}, format: :json
    #   parsed_response = JSON.parse(response.body)
    #   expect(parsed_response['status']).to eq("unauthorized")
    # end

    # it "returns notified false with good API Key" do
    #   post :create, {value: 20, capture_time: Time.now, notified: false, sensor_id: 1, api_key: "NR71J65VHMH5WZ26A1K4"}, format: :json
    #   # parsed_response = JSON.parse(response.body)
    #   expect(response.body['id']).to eq(false)
    # end
  end

end
