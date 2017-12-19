require 'carrierwave/test/matchers'
require 'rails_helper'
require 'spec_helper'
require 'base64'

# https://www.axiomq.com/blog/rspec-and-factorygirl-setup-for-testing-carrierwave-uploaders/
# https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Use-test-factories
# https://groups.google.com/forum/#!msg/carrierwave/z1K0NTCEtik/f-_wniYpVC8J
# https://stackoverflow.com/questions/15552965/carrierwave-be-identical-to-helper-not-working-in-rspec

describe "Picture Uploader" do
  include CarrierWave::Test::Matchers

  let(:cat) { FactoryGirl.create(:cat) }
  let(:uploader) { PictureUploader.new(cat, :picture) }

  before do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    PictureUploader.enable_processing = true
    File.open(path_to_file) { |f| uploader.store!(f) }
  end

  after do
    uploader.remove!
  end

  context 'the thumb version' do
    it "scales down a landscape image to be exactly 100 by 67 pixels" do
      expect(uploader.thumb).to have_dimensions(100, 67)
    end
  end

  context 'the regular version' do
    it "scales down a landscape image to fit within 200 by 200 pixels" do
      expect(uploader).to be_no_larger_than(200, 300)
    end
  end

  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0600)
  end
  it "is the same as the expected thumbnail file" do
    comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","thumb.jpeg")
    expect(uploader.thumb.current_path).to be_identical_to(comparison_file)
  end

  it "is the same as the expected file" do
    comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","cat_uploaded.jpeg")
    expect(uploader.current_path).to be_identical_to(comparison_file)
  end

  it "has the correct format" do
    expect(uploader).to be_format('JPEG')
  end
end
