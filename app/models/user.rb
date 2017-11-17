class User < ApplicationRecord
  #mount_base64_uploader :image, ImageUploader, file_name: -> { 'userpic' }
end
