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

  it 'has a pending scope' do
    performed_review
    create(:pending_review, word: create(:word, postpone: true))
    ids = [pending_review.id]
    review
    expect(Review.pending.count).to eql(1)
    expect(Review.pending.ids).to match ids
  end

  it 'has a passed today scope' do
    ids = [performed_review.id]
    create(:pending_review).perform(false)
    pending_review
    review
    expect(Review.passed_today.count).to eql(1)
    expect(Review.passed_today.ids).to match ids
  end

  it 'has a scope to arrange a group of reviews' do
    create_list(:review, Remember::MAX_PER_DAY + 1, word: word)
    expect { Review.arrange }
    .to change(Review.where(scheduled_for: 10.days.from_now), :count).by -1
  end

  describe '#waiting time' do
    context 'the review has not been performed' do
      it { expect(review.waiting_time).to eql(10) }
    end

    context 'the review has already been performed' do
      it { expect(performed_review.waiting_time).to eql(7) }
    end
  end

  describe '#perform' do
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

  describe '#arrange' do
    it do
      create_list(:review, Remember::MAX_PER_DAY, word: word)
      new_review = build(:review)
      new_review.arrange(10.days.from_now)
      expect(new_review.scheduled_for).to eql 11.days.from_now.to_date
    end
  end
end
