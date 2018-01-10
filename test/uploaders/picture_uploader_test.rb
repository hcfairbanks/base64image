require 'test_helper'
require 'minitest/autorun'
require 'rmagick'

# https://github.com/metaskills/minitest-spec-rails
class PictureUploaderTest < ActiveSupport::TestCase
include Magick




# http://guides.rubyonrails.org/testing.html
# look up
# 2.3 Rails meets Minitest


  test "test of a test" do
    #https://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image
    path_to_file = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")
    img = Magick::Image.ping( path_to_file ).first
    puts "*" * 20
    puts width = img.columns
    # http://www.rubydoc.info/github/carrierwaveuploader/carrierwave/CarrierWave/Test/Matchers/MagickWrapper#height-instance_method
    # This link is from the matchers for rspec, as you can see, I use the same methode here in minitest

    puts height = img.rows
    # https://ruby-doc.org/core-1.9.3/File/Stat.html
    m = File.stat(path_to_file).world_readable?
    puts sprintf("%o", m)
    puts File.stat(path_to_file).mode.to_s(8)[3..5]
# permissions links
# http://rubyforadmins.com/files-and-directories
# http://www.alberts.me/post/checking-file-permissions-with-ruby/



    comparison_file = path_to_file #TODO change this to goldstandard file
    new_file = path_to_file #TODO change this to newly created file
    puts identical_boolean =   FileUtils.identical?(comparison_file,new_file)
    # m = File.stat(path_to_file).world_writable?
    # puts sprintf("%o", m)
    # on the command line
    # stat -c "%a %n" *
    # https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line
    created_file_path = path_to_file #TODO change this to the newly created file
    puts File.file?(created_file_path)

# https://stackoverflow.com/questions/6215889/getting-accurate-file-size-in-megabytes
    compressed_file_size = File.size(created_file_path).to_f / 2**20
    formatted_file_size = '%.2f' % compressed_file_size
    puts formatted_file_size + " MB"

    # compressed_file_size = '%.2f' % (File.size("Compressed/#{project}.tar.bz2").to_f / 2**20)
    # compressed_file_size = (File.size("Compressed/#{project}.tar.bz2").to_f / 2**20).round(2)

    puts File.extname(created_file_path)

    puts "*" * 20



    x = PictureUploader.new()
    assert_equal(5,5)


# file identical
# file size
# permissions on file
# File extention
# height and width



  end
  # context 'thumb version' do
  #   it "scales down a landscape image to be exactly 100 by 67 pixels" do
  #     expect(uploader.thumb).to have_dimensions(100, 67)
  #   end
  # end
  #
  # context 'regular version' do
  #   it "scales down a landscape image to fit within 200 by 200 pixels" do
  #     expect(uploader).to be_no_larger_than(200, 300)
  #   end
  # end
  #
  # it "makes the image readable only to the owner and not executable" do
  #   expect(uploader).to have_permissions(0600)
  # end
  #
  # it "thumbnail is the same as the expected thumbnail file" do
  #   comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","thumb.jpeg")
  #   expect(uploader.thumb.current_path).to be_identical_to(comparison_file)
  # end
  #
  # it "image is the same as the expected image file" do
  #   comparison_file = File.join(Rails.root,"spec","fixtures","binaries","cat_comparison_images","cat_uploaded.jpeg")
  #   expect(uploader.current_path).to be_identical_to(comparison_file)
  # end
  #
  # # This spec may not be needed.
  # it "processes the thumbnail to the proper size" do
  #   expect(File.size(uploader.thumb.current_path)).to eq(65817)
  # end
  #
  # # This spec may not be needed.
  # it "processes the image to the proper size" do
  #   expect(File.size(uploader.current_path)).to eq(80467)
  # end
  #
  # it "obfuscates the image name" do
  #   # Not a great test but it still only tests one thing.
  #   # SecureRandom.uuid creates string size 36 + 5 '.jpeg' = 41
  #   expect(uploader.identifier.size).to equal(41)
  #   expect(uploader.identifier).to match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}(.jpeg)\z/)
  #   expect(uploader.identifier).to_not eq("cat_1.jpeg")
  # end
  #
  # it "has the correct format" do
  #   expect(uploader).to be_format("JPEG")
  # end


end
