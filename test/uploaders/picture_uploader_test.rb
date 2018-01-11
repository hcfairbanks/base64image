require 'test_helper'
require 'minitest/autorun'
require 'rmagick'
require 'base64'

# https://github.com/metaskills/minitest-spec-rails
class PictureUploaderTest < ActiveSupport::TestCase
include Magick




# http://guides.rubyonrails.org/testing.html
# look up
# 2.3 Rails meets Minitest

  test "testing cats yml" do
    #puts cats(:one).name
    PictureUploader.enable_processing = true
    folder_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images")
    file_path = File.join(folder_path,"cat_1.jpeg")
    cat_image = Base64.encode64(File.open(file_path).read)
    data_url = "data:image/jpeg;base64,#{cat_image}"
    cat = Cat.create(name:'test',picture:data_url) # TODO figure out how to put the picture in the yaml and perhaps use that ?
    x = PictureUploader.new(cat, :picture)
    File.open(file_path) { |f| x.store!(f) }
    puts x.current_path
    #puts x.inspect

  end

  test "test of a test" do


    puts cats(:one).name

    # https://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    path_to_file_permissions = File.join(Rails.root,"public","uploads","development","cat","picture","36","b1b854d0-59c1-4118-b03a-4c2d1c267807.jpg")
    img = Magick::Image.ping( path_to_file ).first




    assert_equal(5,5)

    # file identical
    # file size
    # permissions on file
    # File extention
    # height and width

  end
  test "thumb version scales down a landscape image to be exactly 100 by 67 pixels" do
    #expect(uploader.thumb).to have_dimensions(100, 67)
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    img = Magick::Image.ping( path_to_file ).first
    puts width = img.columns
    # http://www.rubydoc.info/github/carrierwaveuploader/carrierwave/CarrierWave/Test/Matchers/MagickWrapper#height-instance_method
    # This link is from the matchers for rspec, as you can see, I use the same methode here in minitest
    puts height = img.rows
  end

  test "regular version scales down a landscape image to fit within 200 by 200 pixels" do
    #expect(uploader).to be_no_larger_than(200, 300)
  end

  test "makes the image readable only to the owner and not executable" do
    # m = File.stat(path_to_file).world_writable?
    # puts sprintf("%o", m)
    # on the command line
    # stat -c "%a %n" *
    # https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line
    # https://ruby-doc.org/core-1.9.3/File/Stat.html

    #expect(uploader).to have_permissions(0600)
    #https://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    path_to_file_permissions = File.join(Rails.root,"public","uploads","development","cat","picture","36","b1b854d0-59c1-4118-b03a-4c2d1c267807.jpg")
    img = Magick::Image.ping( path_to_file ).first

    m = File.stat(path_to_file).world_readable?
    puts sprintf("%o", m)
    puts File.stat(path_to_file_permissions).mode.to_s(8)[2..5]
    # permissions links
    # http://rubyforadmins.com/files-and-directories
    # http://www.alberts.me/post/checking-file-permissions-with-ruby/

    # permissions in carrierwave matchers
    # https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/test/matchers.rb
    #  (File.stat(@actual.path).mode & 0777) == @expected
    puts 'permissions test'
    puts (File.stat(path_to_file_permissions).mode & 0777).to_s(8) == "600"
    #  (File.stat(File.dirname @actual.path).mode & 0777) == @expected
    # "expected #{@actual.current_path.inspect} to have permissions #{@expected.to_s(8)}, but they were #{(File.stat(@actual.path).mode & 0777).to_s(8)}"


  end
  #
  test "thumbnail is the same as the expected thumbnail file" do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    comparison_file = path_to_file #TODO change this to goldstandard file
    new_file = path_to_file #TODO change this to newly created file
    puts identical_boolean =   FileUtils.identical?(comparison_file,new_file)


    #comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","thumb.jpeg")
    #expect(uploader.thumb.current_path).to be_identical_to(comparison_file)
  end
  #
  test "image is the same as the expected image file" do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    puts File.file?(path_to_file)
    #comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","cat_uploaded.jpeg")
    #expect(uploader.current_path).to be_identical_to(comparison_file)
  end
  #
  # # This spec may not be needed.
  test "processes the thumbnail to the proper mb size" do
    #expect(File.size(uploader.thumb.current_path)).to eq(65817)
    # https://stackoverflow.com/questions/6215889/getting-accurate-file-size-in-megabytes
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    compressed_file_size = File.size(path_to_file).to_f / 2**20
    formatted_file_size = '%.2f' % compressed_file_size
    puts formatted_file_size + " MB"

    # compressed_file_size = '%.2f' % (File.size("Compressed/#{project}.tar.bz2").to_f / 2**20)
    # compressed_file_size = (File.size("Compressed/#{project}.tar.bz2").to_f / 2**20).round(2)

  end
  #
  # This spec may not be needed.
  test "processes the image to the proper size" do
    #expect(File.size(uploader.current_path)).to eq(80467)
  end
  #
  test "obfuscates the image name" do
    # Not a great test but it still only tests one thing.
    # SecureRandom.uuid creates string size 36 + 5 '.jpeg' = 41
    # expect(uploader.identifier.size).to equal(41)
    # expect(uploader.identifier).to match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}(.jpeg)\z/)
    # expect(uploader.identifier).to_not eq("cat_1.jpeg")
  end
  #
  test "has the correct format" do
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    img = Magick::Image.ping( path_to_file ).first
    puts format = img.format
    puts File.extname(path_to_file)
    #expect(uploader).to be_format("JPEG")
  end


end
