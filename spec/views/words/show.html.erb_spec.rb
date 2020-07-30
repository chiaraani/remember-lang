require 'rails_helper'

RSpec.describe "words/show", type: :view do
  before(:each) do
    @word = assign(:word, create(:word, spelling: "Spelling", definers: [create(:word, spelling: 'Hi'), create(:word, spelling: 'Hello')] ))
    create(:review, word: @word)
    create(:performed_review, word: @word)
    @review = assign(:review, @word.reviews.new)
    render
  end

  it "renders attributes in <p>" do
    expect(rendered).to match(/Spelling/)
  end

  it "renders a list of reviews" do
    assert_select "tr>td", :text => 10.days.from_now.to_date.to_formatted_s(:long_ordinal)
    assert_select "tr>td", :text => 3.days.ago.to_date.to_formatted_s(:long_ordinal)
    assert_select "tr>td", :text => true.to_s
  end

  it "renders new review form" do
    render

    assert_select "form[action=?][method=?]", word_reviews_path(@word), "post" do

      assert_select "input[name=?]", "review[scheduled_for]"
      assert_select "input[value=?]", (Date.tomorrow).to_s
    end
  end

  it "renders a list of its definer words" do
    render
    assert_select "h2", text: 'Definers'
    assert_select "tr>td", :text => "Hi".to_s
    assert_select "tr>td", :text => "Hello".to_s
  end
end
