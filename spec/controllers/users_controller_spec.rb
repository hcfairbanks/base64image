require 'rails_helper'
require 'spec_helper'
require 'base64'

RSpec.describe UsersController, type: :controller do

  file_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)

  data_url = "data:image/jpeg;base64,#{cat_image}"

#  cat_image = Base64.urlsafe_encode64(File.open(file_path).read)
#look at this
#https://stackoverflow.com/questions/23690484/unit-test-a-method-that-prints-a-png-from-a-base64-string

  let(:valid_attributes) {
    {
      name: "John",
      age: 30,
      resume: data_url
    }
  }


  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    it "creates a new user" do
      #expect { post :document_create, params: {resume: valid_attributes} }.to change(User, :count).by(1)
      expect { post :document_create,valid_attributes }.to change(User, :count).by(1)
      expect(assigns(:user).errors.size).to eq(0)
      #TODO In another test, check to see if the file was writen to the hd. 
    end
  end

  # it "serve user thumnail avatar" do
  #   get :serve_small, params: {id: @admin.to_param}
  #   expect(response.header['Content-Type']).to eq("image/jpeg")
  #   expect(response.header['Content-Disposition']).to eq("inline; filename=\"small_1.jpg\"")
  #   expect(controller.headers["Content-Transfer-Encoding"]).to eq("binary")
  # end

end
