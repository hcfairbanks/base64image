require 'rails_helper'

RSpec.describe Cat, type: :model do
  file_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
  cat_image = Base64.encode64(File.open(file_path).read)
  data_url = "data:image/jpeg;base64,#{cat_image}"

  let(:valid_attributes) {
    {
      name: "John",
      picture: data_url
    }
  }

  let(:update_attributes) {
    {
      name: "John",
      picture: data_url
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      picture: ""
    }
  }

    it "is valid with a name and an image" do
      test_cat = Cat.create(valid_attributes)
      expect(test_cat).to be_valid
    end

    it "is invalid without a name" do
      expect(Cat.create(invalid_attributes)).to be_invalid
    end

    it "returns the correct error msg" do
      cat = Cat.create(invalid_attributes)
      expect(cat.errors[:name]).to include("can't be blank")
    end

    # it "creates a new image in the directory" do
    #   post :create, params: {cat: valid_attributes}
    #   created_file_path = File.join(Rails.root,
    #                                 "public","#{assigns(:cat).picture}")
    #   result = File.exist? File.expand_path created_file_path
    #   expect(result).to be true
    # end

    it "can update with valid attributes" do
      cat = Cat.create(valid_attributes)
      cat.update(update_attributes)
      cat.reload
      expect(cat).to be_valid
    end

    # it "updates the requested cat image" do
    #   put :update, params: {id: @cat.to_param, cat: update_attributes}
    #   expect(assigns(:cat).picture_identifier).to_not eq("cat_2.jpeg")
    #   updated_img = File.join(Rails.root,"public","#{assigns(:cat).picture}")
    #   updated_comparison_img = File.join( Rails.root,
    #                                 "spec",
    #                                 "fixtures","binaries",
    #                                 "cat_comparison_images",
    #                                 "cat_uploaded_update.jpeg")
    #   expect(updated_img).to be_identical_to(updated_comparison_img)
    #
    # end

    describe "#destroy" do

      before(:each) do
        @cat = Cat.create(valid_attributes)
      end

      it "decreases the cat count by 1" do
        expect {Cat.destroy(@cat.id)}.to change(Cat, :count).by(-2)
      end

      it "completely removes the cat from the db" do
        Cat.destroy(@cat.id)
        expect(Cat.where(id: @cat.id).count).to eq(0)
      end

      # might be good just to leave this stuff in the uploader specs
      # it "removes the image from the directory" do
      #   cat_img = File.join(Rails.root,"public","#{@cat.picture}")
      #   get :destroy, params: {id: @cat.to_param}
      #   result = File.exist? File.expand_path cat_img
      #   expect(result).to be false
      # end

    end

end
