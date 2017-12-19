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

  # let(:invalid_attributes) {
  #   {
  #     name: "",
  #     picture: ""
  #   }
  # }

  it "create a cat with valid attributes" do
    test_cat = Cat.create(valid_attributes)
    expect(test_cat).to be_valid
  end

  it "can't create a cat with invalid attributes" do
    #expect(Cat.create(invalid_attributes)).to be_falsey
  end


end
