require 'rails_helper'

RSpec.describe "words/definers/index", type: :view do
  before(:each) do
    @word = assign(:word, 
    	create(:word, 
    		spelling: "Spelling", 
    		definers: [create(:word, spelling: 'Hi'), create(:word, spelling: 'Hello')] ))
    render
  end

  it "renders a list of its definer words" do
    render
    assert_select "h2", text: 'Words that define "Spelling"'
    assert_select "tr>td", :text => "Hi".to_s
    assert_select "tr>td", :text => "Hello".to_s
  end

  it "renders a form to add a definer" do
    render

    assert_select "form[action=?][method=?]", word_definers_path(@word), "post" do

      assert_select "input[name=?]", "word[new_definer]"
      assert_select "input[type=submit][value=?]", "Add definer"
    end
  end
end
