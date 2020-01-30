
require "rails_helper"

RSpec.describe WordsHelper, type: :helper do
  describe 'next_review' do
    context 'with future reviews' do
      it 'returns in how many days the next review may be performed' do
        word = create(:review).word
        expect(next_review(word)).to match 'It may be reviewed in 10 days'
      end
    end

    context 'with reviews ready to perform' do
      it do
        word = create(:pending_review).word
        expect(next_review(word)).to match 'It should be reviewed today'
      end
    end

    context 'when no reviews to do either in future or today' do
      it do
        expect(next_review(create(:word))).to match 'It may NOT be reviewed'
      end
    end
  end
end
