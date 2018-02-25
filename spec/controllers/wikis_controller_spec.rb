require 'rails_helper'

RSpec.describe WikisController, type: :controller do

let (:my_user) { create(:user) }
let(:my_wiki) { create(:wiki, user: my_user) }
let(:private_wiki) { create(:wiki, private: true) }

  context "signed out user" do

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #new" do
      it "returns http redirect" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      it "returns http redirect" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "returns http redirect" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

  end

  context "signed in user" do

    before do
      sign_in(my_user)
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns [my_wiki] to _wikis" do
        get :index
        expect(assigns(:wikis)).to eq([my_wiki])
      end
    end

    describe "GET show" do
      it "returns http success" do
        get :show, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #show view" do
        get :show, params: { id: my_wiki.id }
        expect(response).to render_template :show
      end

      it "assigns my_wiki to @wiki" do
        get :show, params: { id: my_wiki.id }
        expect(assigns(:wiki)).to eq(my_wiki)
      end
    end

    describe "GET new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template :new
      end

      it "initializes @wiki" do
        get :new
        expect(assigns(:wiki)).not_to be_nil
      end
    end

    describe "POST create" do
      it "increases the number of wikis by 1" do
        expect{ post :create, params: { wiki: { title: "New Wiki", body: "This is the New Wiki Body", user: my_user } } }.to change(Wiki,:count).by(1)
      end

      it "assigns Wiki.last to @wiki" do
        post :create, params: { wiki: { title: "New Wiki", body: "This is the New Wiki Body", user: my_user } }
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new wiki" do
        post :create, params: { wiki: { title: "New Wiki", body: "This is the New Wiki Body", user: my_user } }
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, params: { id: my_wiki.id }
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: my_wiki.id }
        wiki_instance = assigns(:wiki)

        expect(wiki_instance.id).to eq my_wiki.id
        expect(wiki_instance.title).to eq my_wiki.title
        expect(wiki_instance.body).to eq my_wiki.body
      end

      it "returns http redirect for someone elses private wiki" do
        get :edit, params: { id: private_wiki.id }
        expect(response).to redirect_to wiki_path
      end

      it "flashes #notice not allow to edit private wiki" do
        get :edit, params: { id: private_wiki.id }
        expect(flash.now[:notice]).to be_present
      end

    end

    describe "PUT update" do
      it "updates wiki with expected attributes" do
        new_title = "New Wiki Title"
        new_body = "New Wiki Body"

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body, user: my_user } }

        updated_wiki = assigns(:wiki)
        expect(updated_wiki.id).to eq my_wiki.id
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
      end

      it "redirects to the updated wiki" do
        new_title = "New Wiki Title"
        new_body = "This is the New Wiki Body!!"

        put :update, params: { id: my_wiki.id, wiki: { title: new_title, body: new_body, user: my_user } }
        expect(response).to redirect_to my_wiki
      end
    end

    describe "DELETE destroy" do
      it "deletes the wiki" do
        delete :destroy, params: { id: my_wiki.id }
        count = Wiki.where({id: my_wiki.id}).size
        expect(count).to eq 0
      end

      it "redirects to wikis index" do
        delete :destroy, params: { id: my_wiki.id }
        expect(response).to redirect_to wikis_path
      end

      it "does not delete someone elses wiki" do
        delete :destroy, params: { id: private_wiki.id }
        count = Wiki.where({id: private_wiki.id}).size
        expect(count).to eq 1
      end

    end

  end

end
