require 'rails_helper'

RSpec.describe Word, type: :model do
  let(:word) { create(:word) }
  describe 'spelling' do
    it 'must be present' do
      expect(Word.create(spelling: nil).errors.messages.count).to eql(1)
    end
    it 'must be unique' do
      create(:word, spelling: 'hello')
      expect(Word.create(spelling: 'hello').errors.messages.count).to eql(1)
    end
  end

  describe 'reviews' do
    it 'is dependent' do
      word.reviews.create!(scheduled_for: Date.new(2018))
      Word.first.destroy
      expect(Review.all.count).to eql(0)
    end
  end

  describe '#last_performed_review' do
    it do
      create(:performed_review, word: word, performed_at: 10.days.ago)
      selected = create(:performed_review, word: word)
      create(:pending_review, word: word)
      expect(word.last_performed_review).to match selected
    end
  end

  describe '#create_next_review' do
    let(:method) { word.create_next_review }
    it do
      create(:performed_review, word: word)
      expect { method }.to change(word.reviews, :count).by(1)
    end

    context "if last review was passed," do
      it "creates a new review which has a longer waiting time" do
        create(:performed_review, word: word, passed: true)
        method
        expect(word.reviews.last.waiting_time).to be > word.last_performed_review.waiting_time
      end
    end

    context "if last review was not passed," do
      it "creates a review for tomorrow" do
        create(:performed_review, word: word, passed: false)
        method
        expect(word.reviews.last.scheduled_for).to match Date.tomorrow
      end
    end
  end
end
