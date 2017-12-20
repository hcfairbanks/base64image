class Cat < ApplicationRecord
  mount_base64_uploader :picture, PictureUploader
  validates :name, presence: true
  #serialize :picture, JSON # If you use SQLite, add this line.
end
