require 'rails_helper'

RSpec.describe Word, type: :model do
  let(:word) { create(:word) }
  describe 'spelling' do
    it 'must be present' do
      expect(Word.create(spelling: nil).valid?).to be_falsy
    end
    it 'must be unique' do
      create(:word, spelling: 'hello')
      expect(Word.create(spelling: 'hello').valid?).to be_falsy
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

    describe 'add_definer' do
      it 'invalidates to have same word as defined and definer' do
        expect { word.add_definer defined.spelling }.to_not change(word.reload, :definer_ids)
        expect(word.add_definer defined.spelling).to be false
        expect(word.add_definer create(:word).spelling).to be true
      end

      it 'returns false if blank' do
         expect(word.add_definer '').to be false        
      end
    end
  
    describe 'new_definer' do
      it 'is accessible' do
        word.new_definer = 'some'
        expect(word.new_definer).to eq 'some'
      end

      it 'is not blank' do
        word.new_definer = ''
        expect(word.invalid?).to be true
      end

      it 'must be a word spelling' do
        word.new_definer = 'akldakf'
        expect(word.invalid?).to be true
      end

      it 'must not be its own spelling' do
        word.new_definer = word.spelling
        expect(word.invalid?).to be true
      end

      it 'must not be defined by the same word that is going to define ' do
        word.new_definer = defined.spelling
        expect(word.invalid?).to be true
      end 
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
    context 'if no performed reviews,' do
      it 'returns false' do
        expect(word.learned).to be_falsy
      end
    end

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


  describe '#should_postpone' do
    context 'if definers are not learned,' do
      it 'postpones itself' do
        word.definers.create(attributes_for :word)
        word.should_postpone
        expect(word.reload.postpone).to be_truthy
      end

      it 'postpones words that defines' do
        word.definers.create(attributes_for :word)
        subject = word.defined.create(attributes_for :word)
        word.should_postpone
        expect(subject.reload.postpone).to be_truthy
      end
    end

    context 'if definers are learned,' do
      it 'does not postpone itself' do
        create(:performed_review, word: word, passed: true, created_at: 2.months.ago)
        subject = word.defined.create(attributes_for :word)
        subject.should_postpone
        expect(subject.reload.postpone).to be_falsy
      end

      it 'unpostpones itself' do
        create(:performed_review, word: word, passed: true, created_at: 2.months.ago)
        subject = word.defined.create(attributes_for :word, postpone: true)
        subject.should_postpone
        expect(subject.reload.postpone).to be_falsy
      end
    end

    context 'when it has no definers,' do
      it 'does not postpone itself' do
        word.should_postpone
        expect(word.reload.postpone).to be_falsy
      end
    end

    context 'when it was learned,' do
      it 'makes its defined words to execute should_postpone' do
        create(:performed_review, word: word, passed: true, created_at: 2.months.ago)
        subject = word.defined.create(attributes_for :word, postpone: true)
        word.should_postpone
        expect(subject.reload.postpone).to be_falsy
      end
    end
  end
end
