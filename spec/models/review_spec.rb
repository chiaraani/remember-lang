require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:word) { create(:word) }
  let(:review) { create(:review, word: word) }
  let(:pending_review) { create(:pending_review, word: word) }
  let(:done_review) { create(:done_review, word: word) }

  it 'belongs to a word' do
    expect(review.word).to be_a Word
  end

  it 'requires scheduled_for' do
    expect(Review.create(word: word).errors.messages.count).to eql(1)
  end

  it 'has a pending group' do
    ids = [pending_review.id]
    review
    done_review
    expect(Review.pending.count).to eql(1)
    expect(Review.pending.ids).to match ids
  end

  describe 'meantime' do
    context 'the review has not been done' do
      it { expect(review.meantime).to eql(10) }
    end
    context 'the review has already been done' do
      it { expect(done_review.meantime).to eql(7) }
    end
  end
  describe 'previous' do
    context 'finds a previous review' do
      it do
        previous = done_review
        expect(review.previous).to match previous
      end
    end
    context 'when no previous review' do
      it 'returns a new review' do
        expect(review.previous.created_at.to_date).to match 5.days.ago.to_date
        expect(review.previous.word).to match word
        expect(review.previous.done_at.to_date).to match review.created_at.to_date
      end
    end
  end
end
