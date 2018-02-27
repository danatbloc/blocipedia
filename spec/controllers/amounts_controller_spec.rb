require 'rails_helper'

RSpec.describe AmountsController, type: :controller do

  let(:admin) { create(:user, role: "admin") }
  let(:standard_user) { create(:user) }
  let(:my_amount) { create(:amount) }

  context "standard user" do

    before do
      sign_in(standard_user)
    end

    describe "GET index" do
      it "returns http redirect" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    describe "GET new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create, params: { amount: { price: 3000 } }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, params: { id: my_amount.id }
        expect(response).to redirect_to(root_path)
      end
    end

    describe "PUT update" do
      it "returns http redirect" do
        new_price = 12345
        put :update, params: { id: my_amount.id, amount: { price: new_price } }

        expect(response).to redirect_to(root_path)
      end
    end

  end

  context "admin user" do

    before do
      sign_in(admin)
    end

    describe "GET #index" do

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns my_amount to @amount" do
        get :index
        expect(assigns(:amounts)).to eq([my_amount])
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "initializes @amount" do
        get :new
        expect(assigns(:amount)).not_to be_nil
      end
    end

    describe "GET #create" do
      it "doesn't increase the number of amounts" do
        post :create, params: { amount: { price: 3000 } }
        expect(Amount.all.count).to eq(1)
      end

      it "assigns Topic.first to @amount" do
        post :create, params: { amount: { price: 3000 } }
        expect(assigns(:amount)).to eq Amount.first
      end

      it "redirects to index" do
        post :create, params: { amount: { price: 3000 } }
        expect(response).to redirect_to(amounts_path)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: my_amount.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_amount.id }
        expect(response).to render_template :edit
      end

      it "assigns amount to be updated to @amount" do
        get :edit, params: { id: my_amount.id }
        amount_instance = assigns(:amount)

        expect(amount_instance.id).to eq my_amount.id
        expect(amount_instance.price).to eq my_amount.price
      end
    end

    describe "GET #update" do
      it "updates amount with expected attributes" do
        new_price = 12345
        put :update, params: { id: my_amount.id, amount: { price: new_price } }

        updated_amount = assigns(:amount)
        expect(updated_amount.id).to eq my_amount.id
        expect(updated_amount.price).to eq new_price

      end

      it "redirects to the updated amount" do
        new_price = 12345
        put :update, params: { id: my_amount.id, amount: { price: new_price } }

        expect(response).to redirect_to amounts_path
      end
    end

  end

end
