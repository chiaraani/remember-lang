require "rails_helper"

RSpec.describe Remember::Lang::VERSION do
  it "is a string" do
    expect(Remember::Lang::VERSION).to be_a String
  end
end
