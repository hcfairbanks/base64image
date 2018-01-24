require 'carrierwave/test/matchers'
require 'rails_helper'
require 'spec_helper'
require 'base64'

describe "Picture Uploader" do
  include CarrierWave::Test::Matchers

  let(:cat) { FactoryBot.create(:cat) }
  let(:uploader) { PictureUploader.new(cat, :picture) }

  before do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    PictureUploader.enable_processing = true
    File.open(path_to_file) { |f| uploader.store!(f) }
  end

  after do
    uploader.remove!
  end

  context 'thumb version' do
    it "scales down a landscape image to be exactly 100 by 67 pixels" do
      expect(uploader.thumb).to have_dimensions(100, 67)
    end
  end

  context 'regular version' do
    it "scales down a landscape image to fit within 200 by 200 pixels" do
      expect(uploader).to be_no_larger_than(200, 300)
    end
  end

  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0600)
  end

  it "thumbnail is the same as the expected thumbnail file" do
    comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","thumb.jpeg")
    expect(uploader.thumb.current_path).to be_identical_to(comparison_file)
  end

  it "image is the same as the expected image file" do
    comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","cat_uploaded.jpeg")
    expect(uploader.current_path).to be_identical_to(comparison_file)
  end

  # This spec may not be needed.
  it "processes the thumbnail to the proper size" do
    expect(File.size(uploader.thumb.current_path)).to eq(65817)
  end

  # This spec may not be needed.
  it "processes the image to the proper size" do
    expect(File.size(uploader.current_path)).to eq(80467)
  end

  it "obfuscates the image name" do
    # Not a great test but it still only tests one thing.
    # SecureRandom.uuid creates string size 36 + 5 '.jpeg' = 41
    expect(uploader.identifier.size).to equal(41)
    expect(uploader.identifier).to match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}(.jpeg)\z/)
    expect(uploader.identifier).to_not eq("cat_1.jpeg")
  end

  it "has the correct format" do
    expect(uploader).to be_format("JPEG")
  end

end
