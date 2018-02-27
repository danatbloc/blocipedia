require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

  let(:my_user) { create(:user) }
  let(:premium_user) { create(:user, role: 'premium') }

  context "guest user" do

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  context "standard user" do

    before do
      sign_in(my_user)
      create(:amount)
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

  end

  context "admin or premium user" do

    before do
      sign_in(premium_user)
    end

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

  end


end
