require 'rails_helper'

RSpec.describe WelcomeController, type: :controller, developer_strategy: true do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
end
