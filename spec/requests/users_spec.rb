require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /show" do
    let(:user) { create(:user) }
    it "returns http success" do
      sign_in user
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    let(:user) { create(:user) }
    it "returns http success" do
      sign_in user
      get edit_user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

end
