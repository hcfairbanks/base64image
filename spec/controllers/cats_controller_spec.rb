require 'rails_helper'
require 'spec_helper'
require 'base64'

RSpec.describe CatsController, type: :controller do
  file_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)
  data_url = "data:image/jpeg;base64,#{cat_image}"

  let(:valid_attributes) {
    {
      name: "Mr. Fluffy Bottom",
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
    it "creates a new cat" do
      expect { post :create, params: {cat: valid_attributes} }.to change(Cat, :count).by(1)
      expect(assigns(:cat).errors.size).to eq(0)

      # TODO Make these seperate tests
      created_file_path = File.join(Rails.root,"public","#{assigns(:cat).picture}")
      result = File.exist? File.expand_path created_file_path
      expect(result).to be true
      expect(File.size(created_file_path)).to eq(3210265)


    end
  end

  # describe "GET #show user" do
  #   it "assigns users to @users" do
  #     get :show, params: {id: user_bob.to_param}
  #     expect(assigns(:user)).to eq(user_bob)
  #   end
  #   it "renders the :show template" do
  #     get :show, params: {id: user_bob.to_param}
  #     expect(response).to render_template("show")
  #   end
  # end

  # describe "GET #new user" do
  #   it "assigns a new User to @user" do
  #     get :new
  #     expect(assigns(:user)).to be_a_new(User)
  #   end
  #   it "renders the :new template" do
  #     get :new
  #     expect(response).to render_template("new")
  #   end
  # end

  # describe "GET #edit user" do
  #   it "assigns the requested user to @user" do
  #     get :edit, params: {id: user_bob.to_param}
  #     expect(assigns(:user)).to eq(user_bob)
  #   end
  #   it "renders the :edit template" do
  #     get :edit, params: {id: user_bob.to_param}
  #     expect(response).to render_template("edit")
  #   end
  # end
  # describe "POST #create user" do
  #
  #   context "with valid attributes" do
  #     it "saves the new user in the database" do
  #       expect { post :create, params: {user: valid_attributes} }.to change(User, :count).by(1)
  #     end
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
  #   end
  #
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

  # describe "PUT #update user" do
  #
  #   context "with valid attributes" do
  #     it "updates the requested user" do
  #       put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
  #       expect(assigns(:user)).to be_valid
  #     end
  #     it "updates the requested users image" do
  #       put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
  #       expect(assigns(:user).avatar_identifier).to eq("2.jpg")
  #     end
  #     it "redirects to users#show" do
  #       put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
  #       expect(response).to redirect_to(user_bob)
  #     end
  #     it "produces valid update flash message" do
  #       put :update, params: {id: user_bob.to_param, user: update_valid_attributes}
  #       expect(flash[:notice]).to match(I18n.t("user.successfully-updated"))
  #     end
  #
  #   end

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
