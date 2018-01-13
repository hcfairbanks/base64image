require 'test_helper'
require 'minitest/autorun'
require 'rmagick'
require 'base64'

# file identical
# file size
# permissions on file
# File extention
# height and width

# Notes

# General
# http://www.rubydoc.info/github/carrierwaveuploader/carrierwave/CarrierWave/Test/Matchers/MagickWrapper#height-instance_method
# This link is from the matchers for rspec, as you can see, I use the same methode here in minitest
# http://guides.rubyonrails.org/testing.html
# https://github.com/metaskills/minitest-spec-rails


# File Size
# https://stackoverflow.com/questions/6215889/getting-accurate-file-size-in-megabytes

# permissions links
# http://rubyforadmins.com/files-and-directories
# http://www.alberts.me/post/checking-file-permissions-with-ruby/
# https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line
# https://ruby-doc.org/core-1.9.3/File/Stat.html

# permissions in carrierwave matchers
# https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/test/matchers.rb

# Image Dimensions
# https://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image


class PictureUploaderTest < ActiveSupport::TestCase
include Magick
  # called before every single test
  setup do
    #puts cats(:one).name
    #path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    PictureUploader.enable_processing = true
    folder_path = File.join(Rails.root,"test","fixtures","files","cat_images")
    folder_path_comparison = File.join(Rails.root,"test","fixtures","files","cat_comparison_images")
    file_path = File.join(folder_path,"cat_1.jpeg")
    @file_path_comparison = File.join(folder_path_comparison,"cat_uploaded.jpeg")
    cat_image = Base64.encode64(File.open(file_path).read)
    data_url = "data:image/jpeg;base64,#{cat_image}"
    cat = Cat.create(name:'test',picture:data_url) # TODO figure out how to put the picture in the yaml and perhaps use that ?
    @uploader = PictureUploader.new(cat, :picture)
    File.open(file_path) { |f| @uploader.store!(f) } # I belive this is to write the file to the actual disk for testing ?
    # puts uploader.current_path
    # puts x.inspect
  end

  test "regular version scales down a landscape image to fit within 200 by 200 pixels" do
    img = Magick::Image.ping( @uploader.current_path ).first

    assert_equal(200,img.columns) # Width
    assert_equal(133,img.rows) # height
  end

  test "thumb version scales down a landscape image to be exactly 100 by 67 pixels" do
    img = Magick::Image.ping( @uploader.thumb.current_path ).first

    assert_equal(100,img.columns) # Width
    assert_equal(67,img.rows) # height
  end

  test "makes the image readable only to the owner and not executable" do
    file_permissions = File.stat(@uploader.current_path).mode.to_s(8)[2..5]
    assert_equal("0600",file_permissions)

    file_permissions = (File.stat(@uploader.current_path).mode & 0777).to_s(8)
    assert_equal("600",file_permissions)
  end

  test "thumbnail is the same as the expected thumbnail file" do
    assert(FileUtils.identical?(@file_path_comparison,@uploader.current_path))
  end

  test "image is the same as the expected image file" do
    assert_equal(true, File.file?(@uploader.current_path) )
  end

  # # This spec may not be needed.
  test "processes the thumbnail to the proper mb size" do
    file_size = File.size(@uploader.thumb.current_path)
    assert_equal(65817,file_size)
  end

  # This spec may not be needed.
  test "processes the image to the proper size" do
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
    assert_equal(".jpeg",File.extname(@uploader.current_path))
  end

end
