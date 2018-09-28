require "rails_helper"

RSpec.describe ReviewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/").to route_to("reviews#index")
    end

    it "routes to #create" do
      expect(:post => "/words/1/reviews").to route_to("reviews#create", :word_id => '1')
    end

    it "routes to #perform" do
      expect(:get => "/reviews/perform").to route_to("reviews#perform")
    end

    it "routes to #update" do
      expect(:post => "/reviews/perform").to route_to("reviews#update")
    end
  end
end
