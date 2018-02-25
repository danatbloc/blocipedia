require 'rails_helper'
include SessionHelper

RSpec.describe Users::SessionsController, type: :controller do

  let(:my_user) { create(:user) }

  context "sign in user" do

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe "GET new " do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST create" do

      it "returns http redirect" do
        post :create, params: { user: { email: my_user.email, password: my_user.password } }
        expect(response).to redirect_to(root_path)
      end

      it "initializes a session" do
        post :create, params: { user: { email: my_user.email, password: my_user.password } }
        expect(@controller.user_signed_in?).to eq(true)
        expect(session[:user_id]).to eq(my_user.id)
      end

      it "assigns standard role" do
        post :create, params: { user: { email: my_user.email, password: my_user.password } }
        expect(my_user.role).to eq("standard")
      end

      it "formats user name" do
        post :create, params: { user: { email: my_user.email, password: my_user.password } }
        expect(my_user.name).to eq(my_user.name.downcase.capitalize)
      end

      it "does not add a user id to session due to missing password" do
        post :create, params: { user: { email: my_user.email } }
        expect(@controller.user_signed_in?).to eq(false)
        expect(session[:user_id]).to be_nil
      end

      it "flashes #error with bad email address" do
        post :create, params: { user: { email: "bad email", password: my_user.password } }
        expect(flash.now[:alert]).to be_present
      end

      it "renders #new with bad email address" do
        post :create, params: { user: { email: "bad email", password: my_user.password } }
        expect(response).to render_template :new
      end

      it "redirects to the root view" do
        post :create, params: { user: { email: my_user.email, password: my_user.password } }
        expect(response).to redirect_to(root_path)
      end

    end


    describe "DELETE sessions/id" do

      before do
        sign_in(my_user)
      end

      it "renders the #home view" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it "deletes the user's session" do
        delete :destroy
        expect(@controller.user_signed_in?).to eq(false)
        expect(session[:user_id]).to be_nil
      end

      it "flashes #notice" do
        delete :destroy
        expect(flash[:notice]).to be_present
      end

    end
  end
end
