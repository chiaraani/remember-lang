require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:word) { Word.create!(spelling: 'hello') }
  let(:review) { Review.create!(scheduled_for: 10.days.from_now, word: word) }
  let(:pending_review) { Review.create!(created_at: 1.week.ago, scheduled_for: 1.day.ago, word: word) }
  let(:made_review) { Review.create!(created_at: 1.week.ago, scheduled_for: 3.days.ago, word: word, made_at: Date.today, passed: true) }

  it 'belongs to a word' do
    expect(review.word).to be_a Word
  end

  it 'requires scheduled_for' do
    expect(Review.create(word: word).errors.messages.count).to eql(1)
  end

  it 'has a pending group' do
    ids = [pending_review.id]
    review
    made_review
    expect(Review.pending.count).to eql(1)
    expect(Review.pending.ids).to match ids
  end

  describe 'meantime' do
    context 'the review has not been made' do
      it { expect(review.meantime).to eql(10) }
    end
    context 'the review has already been made' do
      it { expect(made_review.meantime).to eql(7) }
    end
  end
=begin
  describe 'previous'
    context 'There is a previous review' do
      before do
        made_review
        review
=end
end
