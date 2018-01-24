require 'rails_helper'
require 'spec_helper'
require 'base64'
require 'carrierwave/test/matchers'

RSpec.describe CatsController, type: :controller do
  include CarrierWave::Test::Matchers
  folder_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images")

  file_path = File.join(folder_path,"cat_1.jpeg")
  file_path_update = File.join(folder_path,"cat_2.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)
  cat_image_update = Base64.encode64(File.open(file_path_update).read)
  url_header = "data:image/jpeg;base64"
  data_url = "#{url_header},#{cat_image}"
  data_url_update = "#{url_header},#{cat_image_update}"


  let(:valid_attributes) {
    {
      name: "Mr. Fluffy Bottom",
      picture: data_url
    }
  }

  let(:update_attributes) {
    {
      name: "Mr. Fluffington",
      picture: data_url_update
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      picture: data_url
    }
  }

  describe "#index" do
    it "returns a 200 response" do
      get :index
      expect(response.status).to eq(200)
    end
    it "renders the #index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "#create" do
    context "with valid attributes" do
      it "creates a new cat" do
        expect { post :create, params: {cat: valid_attributes} }.to change(Cat, :count).by(1)
      end

      it "redirects to cats#show" do
        post :create, params: {cat: valid_attributes}
        expect(response).to redirect_to(Cat.last)
      end

      it "produces valid created flash message" do
        post :create, params: {cat: valid_attributes}
        expect(flash[:notice]).to match(I18n.t("cat.created"))
      end
    end

    context "with invalid attributes" do
      it "does not save the new cat in the database" do
        expect { post :create, params: {cat: invalid_attributes}}.to change(Cat, :count).by(0)
      end
      it "re-renders the :new template" do
        post :create, params: {cat: invalid_attributes}
        expect(response).to render_template(:new)
      end
      it "produces correct error message" do
        post :create, params: {cat: invalid_attributes}
        expect(assigns(:cat).errors.messages[:name]).to eq(["can't be blank"])
      end
      it "produces 1 error" do
        post :create, params: {cat: invalid_attributes}
        expect(assigns(:cat).errors.size).to eq(1)
      end
    end

  end

  describe "#show" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end

    it "assigns cat to @cat" do
      get :show, params: {id: @cat.to_param}
      expect(assigns(:cat)).to eq(@cat)
    end
    it "renders the :show template" do
      get :show, params: {id: @cat.to_param}
      expect(response).to render_template("show")
    end
  end

  describe "#new" do
    it "assigns a new Cat to @cat" do
      get :new
      expect(assigns(:cat)).to be_a_new(Cat)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "#edit" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    it "assigns the requested cat to @cat" do
      get :edit, params: {id: @cat.to_param}
      expect(assigns(:cat)).to eq(@cat)
    end
    it "renders the :edit template" do
      get :edit, params: {id: @cat.to_param}
      expect(response).to render_template("edit")
    end
  end

  describe "#update" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    context "with valid attributes" do
      it "updates the requested cat" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(assigns(:cat)).to be_valid
      end

      it "redirects to cats#show" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(response).to redirect_to(@cat)
      end

      it "produces valid update flash message" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(flash[:notice]).to match(I18n.t("cat.updated"))
      end
    end

    context "with invalid attributes" do
      it "assigns the cat" do
        put :update, params: { id: @cat.to_param, cat: invalid_attributes}
        @cat.reload
        expect(@cat.name).to eq(valid_attributes[:name])
      end
      it "returns 1 error" do
        put :update, params: { id: @cat.to_param, cat: invalid_attributes}
        @cat.reload
        expect(assigns(:cat).errors.size).to eq(1)
      end
      it "redirects to cats#edit" do
        put :update, params: {id: @cat.to_param, cat: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

   describe "#destroy" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    it "removes the requested cat from the db" do
      expect { delete :destroy, params: {id: @cat.to_param} }.to change(Cat, :count).by(-1)
    end
    it "redirects to cats#index" do
      delete :destroy, params: {id: @cat.to_param}
      expect(response).to redirect_to(cats_url)
    end

    it "produces valid destroy flash message" do
      delete :destroy, params: {id: @cat.to_param}
      expect(flash[:notice]).to match(I18n.t("cat.destroyed"))
    end

  end

end
