require 'rails_helper'
require 'spec_helper'

RSpec.describe CatsController, type: :controller do

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

end
