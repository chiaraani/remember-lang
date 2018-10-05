require "rails_helper"

RSpec.describe VERSION do
  it "is a string" do
    expect(VERSION).to be_a String
  end
end
