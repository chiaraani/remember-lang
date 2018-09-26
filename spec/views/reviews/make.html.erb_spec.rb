require 'rails_helper'

RSpec.describe "reviews/make", type: :view do
  before(:each) do
    @review = assign(:review, create(:pending_review))
    @review.word.update!(spelling: 'purple')
  end

  it "renders the make review form" do
    render

    assert_select "p", :text => "purple"

    assert_select "form[action=?][method=?]", reviews_make_path, "post" do

      assert_select "input[name=?]", "review[passed]"
    end
  end
end
