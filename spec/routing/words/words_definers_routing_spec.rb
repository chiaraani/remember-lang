require "rails_helper"

RSpec.describe Words::DefinersController, type: :routing do
  describe "routing" do
    it 'routes to #create' do
      expect(:post => "/words/1/definers").to route_to("words/definers#create", :word_id => "1")
    end

    it 'routes to #destroy' do
      expect(:delete => "/words/1/definers/2")
      .to route_to("words/definers#destroy", :word_id => "1", :id => "2")
    end
  end
end