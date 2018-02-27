require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do

  let(:my_user) { create(:user) }

  context "guest user" do

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "instantiates a new user" do
        get :new
        expect(assigns(:user)).to_not be_nil
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET update" do
      it "returns http redirect" do
        get :update
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "signed in user" do

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in(my_user)
    end

    describe "GET new" do

      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(root_path)
      end

    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { user: my_user }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { user: my_user }
        expect(response).to render_template :edit
      end
    end

    describe "PUT update" do
      it "updates user with expected attributes" do
        new_name = "New Name"
        put :update, params: { user: {user_id: my_user.id, name: new_name, email: my_user.email, password: my_user.password } }

        updated_user = assigns(:user)
        expect(updated_user.id).to eq my_user.id
        expect(updated_user.name).to eq new_name
      end

    end

  end

end
