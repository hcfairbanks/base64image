require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe Cat, type: :model do
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
      name: "John",
      picture: data_url
    }
  }

  let(:update_attributes) {
    {
      name: "Sam",
      picture: data_url_update
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      picture: ""
    }
  }

  it "is valid with valid attributes" do
    cat = Cat.create(valid_attributes)
    expect(cat).to be_valid
  end

  it "creates a new image in the directory" do
    cat = Cat.create(valid_attributes)
    created_file_path = File.join(Rails.root,
                                  "public","#{cat.picture}")
    result = File.exist? File.expand_path created_file_path
    expect(result).to be true
  end

  it "is not valid without a name" do
    expect(Cat.create(invalid_attributes)).to be_invalid
  end

  it "fails with correct blank name error msg" do
    cat = Cat.create(invalid_attributes)
    expect(cat.errors[:name]).to include("can't be blank")
  end

  it "updates with valid attributes" do
    cat = Cat.create(valid_attributes)
    cat.update(update_attributes)
    cat.reload
    expect(cat).to be_valid
  end

  it "updates the cat image" do
    cat = Cat.create(valid_attributes)
    cat.update(update_attributes)
    updated_img = File.join(Rails.root,"public","#{cat.picture}")
    updated_comparison_img = File.join( Rails.root,
                                  "spec",
                                  "fixtures","binaries",
                                  "cat_comparison_images",
                                  "cat_uploaded_update.jpeg")
    expect(updated_img).to be_identical_to(updated_comparison_img)
  end

  describe "#destroy," do

    it "decreases the cat count by 1" do
      cat = Cat.create(valid_attributes)
      expect {Cat.destroy(cat.id)}.to change(Cat, :count).by(-1)
    end

    it "completely removes the cat from the db" do
      cat = Cat.create(valid_attributes)
      Cat.destroy(cat.id)
      expect(Cat.where(id: cat.id).count).to eq(0)
    end

    it "removes the image from the directory" do
      cat = Cat.create(valid_attributes)
      cat_img = File.join(Rails.root,"public","#{cat.picture}")
      Cat.destroy(cat.id)
      result = File.exist? File.expand_path cat_img
      expect(result).to be false
    end

  end

end
