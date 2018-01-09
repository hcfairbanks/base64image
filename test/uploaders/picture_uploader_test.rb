require 'test_helper'
require 'minitest/autorun'

# https://github.com/metaskills/minitest-spec-rails
class PictureUploaderTest < ActiveSupport::TestCase

# http://guides.rubyonrails.org/testing.html
# look up
# 2.3 Rails meets Minitest

  test "test of a test" do
    x = PictureUploader.new()
    assert_equal(5,5)
  end


end
