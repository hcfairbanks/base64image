## An application to take base64 files using carrierwave
### Tests Included, RSPEC and Minitest examples

This application is a guide for those wanting to know how to use and test carrierwave with carrierwave-base64.
With this you can convert an image into a base64 string and send it through an ajax call.
There are many things you can do with this. It allows alot of flexability with your front end.
Although I do not cover it here, you can create gui's that allow for multiple image uploads with a preview before editing.
You can delete these preview before uploading. This is done on many websites. I plan on covering this in a later application. for now you can research it [here.](https://github.com/kripken/sql.js/wiki/Display-an-image-stored-in-a-BLOB-in-a-browser)  

### Dependiencies
These instructions are Ubuntu specific, but should work for any debian based linux OS.
You will need to install the following dependiencies.

- Rails 5.0.4
- ruby 2.4.0p0
- sudo apt-get install imagemagick libmagickwand-dev


### Tutorial
Following this short tutorial will allow you to build this app. It requires a basic understanding of rails.

### 1. add gems to gem file
```
 gem 'carrierwave', '~> 1.0'
 gem 'carrierwave-base64'
```
### 2. add "require 'carrierwave' " to config/application.rb
so it looks like this.
```
 require 'carrierwave'
 require_relative 'boot'

 require 'rails/all'
 require 'carrierwave'
 # Require the gems listed in Gemfile, including any gems
 # you've limited to :test, :development, or :production.
 Bundler.require(*Rails.groups)

 module Base64Image
   class Application < Rails::Application
     # Settings in config/environments/* take precedence over those specified here.
     # Application configuration should go into files in config/initializers
     # -- all .rb files in that directory are automatically loaded.
   end
 end
```
### 3. Generate the cat scafold

```rails g scaffold Cat name:string picture:string```

### 4. Generate an uploader

rails generate uploader Picture

Edit the uploader 

app/uploaders/picture_uploader.rb

so it looks like this

```
class PictureUploader < CarrierWave::Uploader::Base
  permissions 0600

  include CarrierWave::RMagick
  storage :file

  def store_dir
    File.join(Rails.root,"public","uploads",Rails.env,"#{model.class.to_s.underscore}", "#{mounted_as}", model.id.to_s)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  process :resize_to_fit => [200, 300]

  version :thumb do
    process resize_to_fit: [100,100]
  end

end
```

### 5. Add line to cat model
```  mount_base64_uploader :picture, PictureUploader```
So that it looks like the following
```
class Cat < ApplicationRecord
  mount_base64_uploader :picture, PictureUploader
end
```
### 6. In your cats model ensure that you remove
the folder structure of the file after deleting it with an after_destroy.
Carrierwave has a bad habbit of leaving empty folders around.
I have also added some basic validation too.

It should look something like this
```
class Cat < ApplicationRecord

  mount_base64_uploader :picture, PictureUploader
  validates :name, presence: true
  after_destroy :remove_picture_directory

  protected

  def remove_picture_directory
    FileUtils.remove_dir(File.join(Rails.root,
                                  "public",
                                  "uploads",
                                  Rails.env,
                                  "cat",
                                  "picture",
                                  self.id.to_s), force: true)
  end

end
```
### 7. adjust the cats index table so you can see your images.
```
<table>
  <thead>
    <tr>
      <th>Image</th>
      <th>Name</th>
      <th>Picture Location</th>
      <th>Picture Name</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @cats.each do |cat| %>
      <tr>
        <td>
          <%= image_tag(cat.picture.thumb, alt: "Cat Thumbnail Picture") %>
        </td>
        <td><%= cat.name %></td>
        <td><%= cat.picture %></td>
        <td><%= cat.picture_identifier %></td>
        <td><%= link_to 'Show', cat %></td>
        <td><%= link_to 'Edit', edit_cat_path(cat) %></td>
        <td><%= link_to 'Destroy', cat, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

### 8. Add a refresh button so you can see your work after you upload
```<%= link_to "Refresh Cats Index", cats_url %>```
### 9. Add a form to the cats index view
```app/views/cats/index.html.erb```
```
<form onsubmit="return send_docs(this)">
  <input type="file" name="file" id="picture">
  <input type="submit">
</form>
```
### 10. Add a javascript function to hanndle the ajax post
```app/assets/javascript/cats.js```
```
 function send_docs(e){
   var reader = new FileReader()
   var files = document.getElementById('picture').files;
   var reader = new FileReader();
   reader.readAsDataURL(files[0]);

   reader.onload = function () {
     base64string = reader.result
     console.log(base64string);
     info = {cat:{
              name: "Mr Furry Bottom",
              picture: base64string
            }};
     $.ajax({
         url: "http://localhost:3000/cats/",
         type: "POST",
         dataType: "JSON",
         data: info,
         success: function (response) {
         //  alert(response);
         }
     });
   }; //End of encoding
 };
```


### 11. run migrations
```rails db:create db:migrate```

### 12. boot application and take it for a spin

### Testing

Included in this application are test examples.
Carrierwave has some rspec tests made for it.
For minitest I created a sample.
These minitest samples were made by reverse engineering the rspec tests.
I plan on making custom asserts for minitest in the near future.

### Running single tests 

run a single minitest test
rails test test/controllers/cats_controller_test.rb:9
run a single rspec spec
rspec spec/controllers/cats_controller_spec.rb:8
