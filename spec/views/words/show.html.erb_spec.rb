require 'rails_helper'

RSpec.describe "words/show", type: :view do
  before(:each) do
    @word = assign(:word, Word.create!(
      :spelling => "Spelling"
    ))
    @word.reviews.create!(expires_at: Date.new(2017, 3, 27), done_at: Date.new(2018), passed: true)
    @word.reviews.create!(expires_at: Date.new(2017, 7, 19))
    render
  end

  it "renders attributes in <p>" do
    expect(rendered).to match(/Spelling/)
  end

  it "renders a list of reviews" do
    assert_select "tr>td", :text => "2017-03-27"
    assert_select "tr>td", :text => "2017-07-19"
  end

  it "renders new review form" do
    render

    assert_select "form[action=?][method=?]", word_reviews_path(@word), "post" do

      assert_select "input[name=?]", "review[expires_at]"
      assert_select "input[value=?]", (Date.today + 1).to_s
    end
  end
end
