require 'carrierwave/test/matchers'
require 'rails_helper'
require 'spec_helper'
require 'base64'
#require 'support/factory_girl'

describe "Picture Uploader" do
  include CarrierWave::Test::Matchers

  #let(:cat) { Cat.create() } #either of these will work
  let(:cat) { FactoryGirl.create(:cat) }
  let(:uploader) { PictureUploader.new(cat, :picture) }

  before do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    PictureUploader.enable_processing = true
    File.open(path_to_file) { |f| uploader.store!(f) }
  end

  # before(:each) do
  #   @cat = FactoryGirl.create(:cat)
  # end

  after do
    PictureUploader.enable_processing = false
    uploader.remove!
  end

  # context 'the thumb version' do
  #   it "scales down a landscape image to be exactly 64 by 64 pixels" do
  #     expect(uploader.thumb).to have_dimensions(64, 64)
  #   end
  # end
  #
  # context 'the small version' do
  #   it "scales down a landscape image to fit within 200 by 200 pixels" do
  #     expect(uploader.small).to be_no_larger_than(200, 200)
  #   end
  # end
  #
  # it "makes the image readable only to the owner and not executable" do
  #   expect(uploader).to have_permissions(0600)
  # end

  it "has the correct format" do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    expect(uploader.current_path).to be_identical_to(path_to_file)
    expect(uploader).to be_format('JPEG')
  end
end
