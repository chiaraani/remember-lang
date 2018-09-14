require 'rails_helper'

RSpec.describe "words/show", type: :view do
  before(:each) do
    @word = assign(:word, Word.create!(
      :spelling => "Spelling"
    ))
    @word.reviews.create!(scheduled_for: Date.new(2017, 3, 27), done_at: DateTime.now, passed: true)
    @word.reviews.create!(scheduled_for: Date.new(2017, 7, 19))
    render
  end

  it "renders attributes in <p>" do
    expect(rendered).to match(/Spelling/)
  end

  it "renders a list of reviews" do
    assert_select "tr>td", :text => Date.new(2017, 3, 27).to_formatted_s(:long_ordinal)
    assert_select "tr>td", :text => Date.new(2017, 7, 19).to_formatted_s(:long_ordinal)
    assert_select "tr>td", :text => true.to_s
  end

  it "renders new review form" do
    render

    assert_select "form[action=?][method=?]", word_reviews_path(@word), "post" do

      assert_select "input[name=?]", "review[expires_at]"
      assert_select "input[value=?]", (Date.tomorrow).to_s
    end
  end
end
