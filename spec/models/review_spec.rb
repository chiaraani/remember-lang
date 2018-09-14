require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) {
    Review.create!(scheduled_for: Date.new(2018),
                   word: Word.create!(spelling: 'hello'))
  }

  it 'belongs to a word' do
    expect(review.word).to be_a Word
  end

  it 'requires scheduled_for' do
    expect(Review.create(word: Word.create!(spelling: 'hello')).errors.messages.count).to eql(1)
  end

  it 'has a pending group' do
    pending_review = review
    Word.first.reviews.create!(scheduled_for: Date.tomorrow)
    Word.first.reviews.create!(scheduled_for: Date.new(2017), done_at: Date.today, passed: true)
    expect(Review.pending.count).to eql(1)
    expect(Review.pending.ids).to match [pending_review.id]
  end

  describe 'meantime' do
    it do
      review = Review.create!(scheduled_for: Date.today + 10,
                   word: Word.create!(spelling: 'hello'))
      expect(review.meantime).to eql(10)
    end
  end
end
