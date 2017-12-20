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

  # it "can't update with invalid attributes" do
  #   test_cat = Cat.create(valid_attributes)
  #   test_cat.update(invalid_attributes)
  #   test_cat.reload
  #   expect(test_cat).to be_invalid
  # end

  describe "delete a cat" do

    it "decreases the cat count by 1" do
      cat = Cat.create(valid_attributes)
      expect {Cat.destroy(cat.id)}.to change(Cat, :count).by(-1)
    end

    it "can't be found in db" do
      cat = Cat.create(valid_attributes)
      Cat.destroy(cat.id)
      expect(Cat.where(id: cat.id).count).to eq(0)
    end

    # it "removes the cat image" do
    #   test_user = Cat.create(valid_attributes)
    #   Cat.destroy(test_user.id)
    #   expect(Image.where(id: test_user.image.id).count).to eq(0)
    # end

  end

end
