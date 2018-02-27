require 'rails_helper'

RSpec.describe AdminsController, type: :controller do

  let(:admin) { create(:user, role: "admin") }
  let(:standard) { create(:user, role: "standard") }

  context "admin user" do

    before do
      sign_in(admin)
    end

    describe "GET #upgrade" do
      it "returns http success" do
        get :upgrade
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "admin user" do

    before do
      sign_in(standard)
    end

    describe "GET #upgrade" do
      it "returns http redirect" do
        get :upgrade
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
