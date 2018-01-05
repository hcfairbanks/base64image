require 'test_helper'

class CatsControllerTest < ActionDispatch::IntegrationTest

  file_path = File.join(Rails.root,"spec","fixtures","binaries","cat_images","cat_1.jpeg")

  cat_image = Base64.encode64(File.open(file_path).read)
  data_url = "data:image/jpeg;base64,#{cat_image}"

  # let(:valid_attributes) {
  #   {
  #     name: "Mr. Fluffy Bottom",
  #     picture: data_url
  #   }
  # }

# check in spec/models/cat_spec.rb#update spec
# result = FileUtils.compare_file(updated_img,updated_comparison_img)
# expect(result).to be true






  setup do # before each
    # DatabaseCleaner.start
    # DatabaseCleaner.clean
    @cat = Cat.create!(name: "Mr. Fluffy Bottom", picture: data_url)
    @cat.save!
#byebug
    # in the test_helper.rb the line
    # fixtures :all
    # will create entries into the db
    # this messes with the db cleaner
  end
  teardown do # before each
  #  DatabaseCleaner.start
  #  DatabaseCleaner.clean
  end

  test "should get index" do
    get cats_url
    assert_response :success
  end

  test "should get new" do
    get new_cat_url
    assert_response :success
  end

  test "should create cat" do
    assert_difference('Cat.count') do
      post cats_url, params: { cat: { name: @cat.name, picture: @cat.picture } }
    end
    assert_redirected_to cat_url(Cat.last)
  end

  test "creates a file" do
    post cats_url, params: { cat: { name: @cat.name, picture: @cat.picture } }
    created_file_path = File.join(Rails.root,
                                  "public","#{assigns(:cat).picture}")
    #expect(FileUtils.identical?(created_img,comparison_image)).to be true
    result = File.exist? File.expand_path created_file_path
    assert(result) #be true
  end

  test "should show cat" do
    get cat_url(@cat)
    assert_response :success
  end

  test "should get edit" do
    get edit_cat_url(@cat)
    assert_response :success
  end

  test "should update cat" do
    patch cat_url(@cat), params: { cat: { name: @cat.name, picture: @cat.picture } }
    assert_redirected_to cat_url(@cat)
  end

  test "should destroy cat" do
    assert_difference('Cat.count', -1) do
      delete cat_url(@cat)
    end

    assert_redirected_to cats_url
  end
end
