require 'rails_helper'

RSpec.describe "words/index", type: :view do
  before(:each) do
    assign(:words, [
      Word.create!(
        :spelling => "Spelling"
      ),
      Word.create!(
        :spelling => "Hello"
      )
    ])
  end

  it "renders a list of words" do
    render
    assert_select "tr>td", :text => "Spelling".to_s
    assert_select "tr>td", :text => "Hello".to_s
  end
end
