require "rails_helper"

RSpec.describe ReviewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/").to route_to("reviews#index")
    end

    it "routes to #create" do
      expect(:post => "/words/1/reviews").to route_to("reviews#create", :word_id => '1')
    end

    it "routes to #do" do
      expect(:get => "reviews/do").to route_to("reviews#do")
    end
  end
end
