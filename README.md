#https://til.codes/testing-carrierwave-file-uploads-with-rspec-and-factorygirl/
#READ THIS
#https://relishapp.com/rspec/rspec-core/v/2-0/docs/hooks/before-and-after-hooks
# minitest
# http://guides.rubyonrails.org/testing.html#rails-sets-up-for-testing-from-the-word-go
# Testing Philosophy
# https://www.youtube.com/watch?v=z9quxZsLcfo&feature=youtu.be
# You dont need database_cleaner
# https://anti-pattern.com/transactional-fixtures-in-rails
#https://blog.bigbinary.com/2016/05/26/rails-5-renamed-transactional-fixtures-to-transactional-tests.html


# https://www.axiomq.com/blog/rspec-and-factorygirl-setup-for-testing-carrierwave-uploaders/
# https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Use-test-factories
# https://groups.google.com/forum/#!msg/carrierwave/z1K0NTCEtik/f-_wniYpVC8J
# https://stackoverflow.com/questions/15552965/carrierwave-be-identical-to-helper-not-working-in-rspec


#http://www.betterspecs.org/
#https://leanpub.com/everydayrailsrspec

# README
# TEST
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
 steps

A. base64 image straight to rails
B. base64 Carrierwave
c. Rspec tests for both



1. add gems to gem file and install

 gem 'carrierwave', '~> 1.0'
 gem 'carrierwave-base64'

 2. add line to config/application.rb

 `` require 'carrierwave' ``

 ``require_relative 'boot'

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
``


  3. Generate scafold

rails g scaffold Cat name:string picture:string

4. Generate uploader

rails generate uploader Picture


5. add line to cat model
``  mount_base64_uploader :picture, PictureUploader``

```
class Cat < ApplicationRecord
  mount_base64_uploader :picture, PictureUploader
end
```

6.  add a ajax post, something like whats on the cat index page
```<p id="notice"><%= notice %></p>

<h1>Cats</h1>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Picture</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @cats.each do |cat| %>
      <tr>
        <td><%= cat.name %></td>
        <td><%= cat.picture %></td>
        <td><%= link_to 'Show', cat %></td>
        <td><%= link_to 'Edit', edit_cat_path(cat) %></td>
        <td><%= link_to 'Destroy', cat, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>

<br>

<%= link_to 'New cat', new_cat_path %>
<script>
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
</script>


<form onsubmit="return send_docs(this)">
  <input type="file" name="file" id="picture">
  <input type="submit">
</form>
```

7. run migrations
rails db:create db:migrate

8. boot application and take it for a spin

9. right rspec tests


-----------------
run single minitest
rails test test/controllers/cats_controller_test.rb:9
run single rspec test
rspec spec/controllers/cats_controller_spec.rb:8
