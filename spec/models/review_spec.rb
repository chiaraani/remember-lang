require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) {
    Review.create!(expires_at: Date.new(2018),
                   word: Word.create!(spelling: 'hello'))
  }
  it 'belongs to a word' do
    expect(review.word).to be_a Word
  end
  it 'requires expires_at' do
    expect(Review.create(expires_at: nil).errors.messages.count).to eql(1)
  end
end
