# I have created a seperate gem for carrier_wave asserts.
# available here
# https://github.com/hcfairbanks/carrierwave_asserts

require 'test_helper'
require 'minitest/autorun'
require 'rmagick'
require 'base64'

class PictureUploaderTest < ActiveSupport::TestCase
include Magick

  setup do
    PictureUploader.enable_processing = true
    file_path = File.join( fixture_path,
                           "files",
                           "cat_images",
                           "cat_1.jpeg")

    data_url  = "data:image/jpeg;base64,"
    data_url += Base64.encode64(File.open(file_path).read)
    cat = Cat.create(name: 'Mr Snuggles', picture: data_url)
    @uploader = PictureUploader.new(cat, :picture)
    File.open(file_path) { |f| @uploader.store!(f) }
  end


  test "img scales down landscape to fit within 200 by 200 pixels" do
    img = Magick::Image.ping( @uploader.current_path ).first

    assert_equal(200,img.columns) # Width
    assert_equal(133,img.rows) # Height
  end

  test "thumbnail scales down to exactly 100 by 67 pixels" do
    img = Magick::Image.ping( @uploader.thumb.current_path ).first

    assert_equal(100,img.columns) # Width
    assert_equal(67,img.rows) # Height
  end

  test "adds the correct permissions" do
    file_permissions = (File.stat(@uploader.current_path).mode & 0777).to_s(8)
    assert_equal("600",file_permissions)
  end

  test "thumbnail is the same as the expected thumbnail file" do
    comparison_file = File.join( fixture_path,
                                 "files",
                                 "cat_comparison_images",
                                 "cat_uploaded.jpeg")

    assert(FileUtils.identical?(comparison_file,@uploader.current_path))
  end

  test "image is the same as the expected image file" do
    assert_equal(true, File.file?(@uploader.current_path) )
  end

  test "processes the thumbnail to the proper mb size" do
    file_size = File.size(@uploader.thumb.current_path)
    assert_equal(65817,file_size)
  end

  test "processes the image to the proper mb size" do
    file_size = File.size(@uploader.current_path)
    assert_equal(80467.0,file_size)
  end

  test "obfuscates the image name" do
    # Not a great test but it still only tests one thing.
    # SecureRandom.uuid creates string size 36 + 5 '.jpeg' = 41
    assert_equal(@uploader.identifier.size,41)
    assert_not_equal(@uploader.identifier,"cat_1.jpeg")
    assert_match( /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}(.jpeg)\z/, @uploader.identifier,['msg'] )
  end

  test "has the correct format" do
    img = Magick::Image.ping( @uploader.current_path ).first
    assert_equal("JPEG",img.format)
  end

end
