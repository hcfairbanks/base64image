
imag_path = Rails.root.join('spec',
                            'fixtures',
                            'binaries',
                            'cat_images',
                            'cat_1.jpeg')

FactoryGirl.define do
  factory :cat do
    name "Fluffy"
    picture { Rack::Test::UploadedFile.new(Rails.root.join( imag_path),
                                                           'image/jpeg') }
  end
end
