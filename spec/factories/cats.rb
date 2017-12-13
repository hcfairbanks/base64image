
imag_path = Rails.root.join('spec', 'fixtures','binaries', 'cat_images', 'cat_1.jpeg')

FactoryGirl.define do
  factory :cat do
    name "Fluffy"
    # after :create do |b|
    #   b.update_column(:picture, imag_path.to_s)
    # end
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures','binaries', 'cat_images', 'cat_1.jpeg'), 'image/jpeg') }
  end
end
