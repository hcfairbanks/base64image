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

RSpec.describe CatsController, type: :controller do
  include CarrierWave::Test::Matchers
  file_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)
  data_url = "data:image/jpeg;base64,#{cat_image}"

  let(:valid_attributes) {
    {
      name: "Mr. Fluffy Bottom",
      picture: data_url
    }
  }

  let(:update_attributes) {
    {
      name: "Mr. Fluffington",
      picture: data_url
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
    #     it "redirects to users#show" do
    #       post :create, params: {user: valid_attributes}
    #       expect(response).to redirect_to(User.last)
    #     end
    #     it "saves the new user avatar" do
    #       post :create, params: {user: valid_attributes}
    #       expect(assigns(:user).avatar_identifier).to eq("1.jpg")
    #     end
    #     it "produces valid create flash message" do
    #       post :create, params: {user: valid_attributes}
    #       expect(flash[:notice]).to match(I18n.t("user.successfully-created"))
    #     end
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
    it "assigns a new User to @user" do
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
  # describe "POST #create user" do
  #   context "with invalid attributes" do
  #     it "does not save the new user in the database" do
  #       expect { post :create, params: {user: invalid_attributes}}.to change(User, :count).by(0)
  #     end
  #     it "re-renders the :new template" do
  #       post :create, params: {user: invalid_attributes}
  #       expect(response).to redirect_to("/new_user_no_devise")
  #     end
  #   end

  # end





  describe "PUT #update cat" do
    before(:each) do
      @cat = Cat.create(valid_attributes)
    end
    context "with valid attributes" do
      it "updates the requested cat" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(assigns(:cat)).to be_valid
      end
      # it "updates the requested cats image" do
      #   put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
      #   expect(assigns(:user).avatar_identifier).to eq("2.jpg")
      # end
      it "redirects to cats#show" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(response).to redirect_to(@cat)
      end
      it "produces valid update flash message" do
        put :update, params: {id: @cat.to_param, cat: update_attributes}
        expect(flash[:notice]).to match(I18n.t("cat.successfully-updated"))
      end
    end
  end



  #   context "with invalid attributes" do
  #     it "assigns the user" do
  #       put :update, params: { id: user_bob.to_param, user: invalid_attributes}
  #       user_bob.reload
  #       expect(user_bob.first_name).to eq("Bob")
  #     end
  #     it "user is not valid" do
  #       put :update, params: { id: user_bob.to_param, user: invalid_attributes}
  #       user_bob.reload
  #       expect(assigns(:user)).to_not be_valid
  #     end
  #     it "returns 1 error" do
  #       put :update, params: { id: user_bob.to_param, user: invalid_attributes}
  #       user_bob.reload
  #       expect(assigns(:user).errors.size).to eq(1)
  #     end
  #     it "redirects to users#edit" do
  #       put :update, params: {id: user_bob.to_param, user: invalid_attributes}
  #       expect(response).to render_template("edit")
  #     end
  #   end
  #
  # end

  #  describe "DELETE #destroy" do
  #   it "destroys the requested user" do
  #     expect { delete :destroy, params: {id: user_bob.to_param} }.to change(User, :count).by(-1)
  #   end
  #   it "redirects admin to users#index" do
  #     delete :destroy, params: {id: user_bob.to_param}
  #     expect(response).to redirect_to(users_url)
  #   end
  #   it "user deletes self" do
  #     expect { delete :destroy, params: {id: @admin.to_param} }.to change(User, :count).by(-1)
  #   end
  #   it "ends user session when user deletes self" do
  #     delete :destroy, params: {id: @admin.to_param}
  #     expect(response).to redirect_to(new_user_session_url)
  #   end
  #   it "produces valid destroy flash message" do
  #     delete :destroy, params: {id: user_bob.to_param}
  #     expect(flash[:notice]).to match(I18n.t("user.user-account-deleted"))
  #   end
  #   it "fails to destroy user with dependent task" do
  #     FactoryGirl.create(:task,reported_by:user_bob)
  #     delete :destroy, params: {id: user_bob.to_param}
  #     expect(assigns(:user).errors.messages[:base]).to match(["Cannot delete record because dependent reports exist"])
  #   end
  #   it "fails to destroy user with dependent comment" do
  #     task_object = FactoryGirl.create(:task,reported_by:user_bob)
  #     FactoryGirl.create(:comment,content: "stuff", user:user_bob, task: task_object)
  #     delete :destroy, params: {id: user_bob.to_param}
  #     expect(assigns(:user).errors.messages[:base]).to match(["Cannot delete record because dependent reports exist"])
  #   end
  #
  #   it "destory the avatar" do
  #     get :destroy_avatar, params: {id: @admin.to_param}
  #     expect(assigns(:user).avatar_identifier).to eq(nil)
  #   end
  #
  # end

end
