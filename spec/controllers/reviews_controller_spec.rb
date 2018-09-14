require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:word) {
    Word.create! spelling: 'clam'
  }

  let(:valid_attributes) {
    {scheduled_for: Date.tomorrow}
  }

  let(:valid_session) { {} }

  describe "POST #create" do
    it "creates a new review" do
      expect {
        post :create, params: {word_id: word.id, review: valid_attributes}, session: valid_session
      }.to change(Review, :count).by(1)
    end

    it "redirects to the created review's word" do
      post :create, params: {word_id: word.id, review: valid_attributes}, session: valid_session
      expect(response).to redirect_to(word)
    end
  end
end
