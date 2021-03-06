require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      create(:review, scheduled_for: Date.new(2018)),
      create(:review, scheduled_for: Date.new(2010))
    ])
  end

  it "renders a list of reviews" do
    render
    assert_select "tr>td", :text => Date.new(2018).to_formatted_s(:long_ordinal)
    assert_select "tr>td", :text => Date.new(2010).to_formatted_s(:long_ordinal)
  end
end
