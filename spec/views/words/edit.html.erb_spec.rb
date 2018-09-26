require 'rails_helper'

RSpec.describe "words/edit", type: :view do
  before(:each) do
    @word = assign(:word, create(:word, spelling: 'pear'))
  end

  it "renders the edit word form" do
    render

    assert_select "form[action=?][method=?]", word_path(@word), "post" do

      assert_select "input[name=?]", "word[spelling]"
      assert_select "input[name='word[spelling]'][value=?]", "pear"
    end
  end
end
