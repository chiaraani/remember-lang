require 'rails_helper'

RSpec.describe "reviews/index", type: :view do
  before(:each) do
    assign(:reviews, [
      Review.create!(
        :expires_at => Date.new(2018),
        :word => Word.create!(spelling: 'hello')
      ),
      Review.create!(
        :expires_at => Date.new(2010),
        :word => Word.first
      )
    ])
  end

  it "renders a list of reviews" do
    render
    assert_select "tr>td", :text => "2018-01-01"
    assert_select "tr>td", :text => "2010-01-01"
  end
end
