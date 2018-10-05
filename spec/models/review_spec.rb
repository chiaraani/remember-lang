require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:word) { create(:word) }
  let(:review) { create(:review, word: word) }
  let(:pending_review) { create(:pending_review) }
  let(:performed_review) { create(:performed_review, word: word) }

  it 'belongs to a word' do
    expect(review.word).to be_a Word
  end

  it 'requires scheduled_for' do
    expect(Review.create(word: word).errors.messages.count).to eql(1)
  end

  it 'has a pending group' do
    performed_review
    ids = [pending_review.id]
    review
    expect(Review.pending.count).to eql(1)
    expect(Review.pending.ids).to match ids
  end

  describe 'meantime' do
    context 'the review has not been performed' do
      it { expect(review.meantime).to eql(10) }
    end

    context 'the review has already been performed' do
      it { expect(performed_review.meantime).to eql(7) }
    end
  end

  describe 'previous' do
    context 'finds a previous review' do
      it do
        previous = performed_review
        expect(review.previous).to match previous
      end
    end

    context 'when no previous review' do
      it 'returns a new review' do
        expect(review.previous.created_at.to_date).to match 5.days.ago.to_date
        expect(review.previous.word).to match word
        expect(review.previous.performed_at.to_date).to match review.created_at.to_date
      end
    end
  end

  describe 'perform' do
    let(:performed) { pending_review.perform(true) }

    it 'saves the time' do
      Time.zone = 'London'
      expect(performed.performed_at.to_s(:long)).to match Time.now.to_s(:long)
    end

    it 'defines passed field' do
      expect(performed.passed).to be true
      expect(create(:pending_review).perform(false).passed).to be false
    end
  end

  it 'ensures the last review was performed when a new review is created' do
    create(:review, word: pending_review.word)
    pending_review.reload
    expect(pending_review.performed_at.to_i).to eql(Time.now.to_i)
    expect(pending_review.passed).to be false
  end
end
