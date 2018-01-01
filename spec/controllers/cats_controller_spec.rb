require 'rails_helper'
require 'spec_helper'
require 'base64'
require 'carrierwave/test/matchers'
#https://til.codes/testing-carrierwave-file-uploads-with-rspec-and-factorygirl/
#READ THIS
#https://relishapp.com/rspec/rspec-core/v/2-0/docs/hooks/before-and-after-hooks
# minitest
# http://guides.rubyonrails.org/testing.html#rails-sets-up-for-testing-from-the-word-go
# Testing Philosophy
# https://www.youtube.com/watch?v=z9quxZsLcfo&feature=youtu.be
# You dont need database_cleaner
# https://anti-pattern.com/transactional-fixtures-in-rails
#https://blog.bigbinary.com/2016/05/26/rails-5-renamed-transactional-fixtures-to-transactional-tests.html

# TODO
# should I change image to picture ?
RSpec.describe CatsController, type: :controller do
  include CarrierWave::Test::Matchers
  folder_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images")

  file_path = File.join(folder_path,"cat_1.jpeg")
  file_path_update = File.join(folder_path,"cat_2.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)
  cat_image_update = Base64.encode64(File.open(file_path_update).read)
  data_url = "data:image/jpeg;base64,#{cat_image}"
  data_url_update = "data:image/jpeg;base64,#{cat_image_update}"


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

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "Post #create cat " do
    it "creates a new cat" do
      expect { post :create, params: {cat: valid_attributes} }.to change(Cat, :count).by(1)
      expect(assigns(:cat).errors.size).to eq(0)
    end

    it "creates a file" do
      post :create, params: {cat: valid_attributes}
      created_file_path = File.join(Rails.root,
                                    "public","#{assigns(:cat).picture}")
      result = File.exist? File.expand_path created_file_path
      expect(result).to be true
    end

    it "process the image to the propper mb size" do
      post :create, params: {cat: valid_attributes}
      created_img = File.join(Rails.root,"public","#{assigns(:cat).picture}")
      expect(File.size(created_img)).to eq(80467)
    end

    it " image is identical to expected image" do
      post :create, params: {cat: valid_attributes}
      created_img = File.join(Rails.root,"public","#{assigns(:cat).picture}")
      comparison_image = File.join( Rails.root,
                                    "spec","fixtures","binaries",
                                    "cat_comparison_images","cat_uploaded.jpeg")
      #expect(FileUtils.identical?(created_img,comparison_image)).to be true
      expect(created_img).to be_identical_to(comparison_image)
    end
    it "redirects to cats#show" do # another one is needed for correct json return
      post :create, params: {cat: valid_attributes}
      expect(response).to redirect_to(Cat.last)
    end
    it "produces valid create flash message" do
      post :create, params: {cat: valid_attributes}
      expect(flash[:notice]).to match(I18n.t("cat.created"))
    end

      context "with invalid attributes" do
        it "does not save the new cat in the database" do
          expect { post :create, params: {cat: invalid_attributes}}.to change(Cat, :count).by(0)
        end
        it "re-renders the :new template" do
          post :create, params: {cat: invalid_attributes}
          expect(response).to render_template(:new)#render(new_cat_path)
        end
        it "produces correct error message" do
          post :create, params: {cat: invalid_attributes}
          expect(assigns(:cat).errors.messages[:name]).to eq(["can't be blank"])
        end
        it "produces  1 error" do
          post :create, params: {cat: invalid_attributes}
          expect(assigns(:cat).errors.size).to eq(1)
        end
      end

  end

  describe "GET #show cat" do
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

  describe "GET #new cat" do
    it "assigns a new Cat to @cat" do
      get :new
      expect(assigns(:cat)).to be_a_new(Cat)
    end
    it "renders the :new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit cat" do
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

  describe "PUT #update cat" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    context "with valid attributes" do
      it "updates the requested cat" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(assigns(:cat)).to be_valid
      end
      it "obfuscates the image name in the directory" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(assigns(:cat).picture_identifier).to_not eq("cat_2.jpeg")
      end
      it "updates the requested cats image" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(assigns(:cat).picture_identifier).to_not eq("cat_2.jpeg")
        updated_img = File.join(Rails.root,"public","#{assigns(:cat).picture}")
        updated_comparison_img = File.join( Rails.root,
                                      "spec",
                                      "fixtures","binaries",
                                      "cat_comparison_images",
                                      "cat_uploaded_update.jpeg")
        expect(updated_img).to be_identical_to(updated_comparison_img)


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
      # before(:each) do
      #   @cat = Cat.create(valid_attributes)
      # end
      it "assigns the cat" do
        put :update, params: { id: @cat.to_param, cat: invalid_attributes}
        @cat.reload
        expect(@cat.name).to eq(valid_attributes[:name])
      end
      it "cat is not valid" do
        put :update, params: { id: @cat.to_param, cat: invalid_attributes}
        @cat.reload
        expect(assigns(:cat)).to_not be_valid
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

   describe "DELETE #destroy" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    it "destroys the requested cat" do
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

    it "destory the picture" do # might be good just to leave this stuff in the uploader specs
      cat_img = File.join(Rails.root,"public","#{@cat.picture}")
      get :destroy, params: {id: @cat.to_param}
      result = File.exist? File.expand_path cat_img
      expect(result).to be false
    end

  end

end
