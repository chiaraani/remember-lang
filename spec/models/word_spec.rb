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

  describe 'defined and definers association' do
    let(:defined) { word.defined.create(attributes_for :word) }
    it "has defined words" do
      expect(word.defined).to include(defined)
    end

    let(:definer) { word.definers.create(attributes_for :word) }
    it "has definer words" do
      expect(word.definers).to include(definer)
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

    context "if there are no reviews," do
      it "creates a review for tomorrow" do
        method
        expect(word.reviews.last.scheduled_for).to match Date.tomorrow
      end
    end
  end

  describe '#learned' do
    context 'if last review was not passed,' do
      it 'returns false' do
        create(:performed_review, word: word, passed: false)
        expect(word.learned).to be_falsy
      end
    end

    context 'if last review was passed and its waiting_time is shorter than learned_time,' do
      it 'returns false' do
        create(:performed_review, word: word, passed: true)
        expect(word.learned).to be_falsy
      end
    end

    context 'if last review was passed and its waiting_time is longer than learned_time,' do
      it 'returns true' do
        create(:performed_review, word: word, passed: true, created_at: 2.months.ago)
        expect(word.learned).to be_truthy
      end
    end
  end
end
