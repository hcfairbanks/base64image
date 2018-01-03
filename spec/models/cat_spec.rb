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

    it "can update with valid attributes" do
      cat = Cat.create(valid_attributes)
      cat.update(update_attributes)
      cat.reload
      expect(cat).to be_valid
    end

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

      it "removes the cat picture directory" do
      # For what ever reason carrierwave does not delete directories
        cat_picture_dir = File.join(Rails.root,
                                    "public",
                                    "uploads",
                                    Rails.env,
                                    "cat",
                                    "picture",
                                    @cat.id.to_s)
        Cat.destroy(@cat.id)
        expect(File.exist?(cat_picture_dir)).to be false
      end
    end

end
