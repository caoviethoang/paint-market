require 'rails_helper'

RSpec.describe "AboutUs", type: :request do
  describe "GET /about-us" do
    it "returns http success" do
      get about_us_path
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get about_us_path
      expect(response).to render_template(:index)
    end

    it "has the correct page title" do
      get about_us_path
      expect(response.body).to include("About Us")
    end
  end
end
