require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:word) {
    create(:word)
  }

  let(:valid_attributes) {
    attributes_for(:review)
  }
  let(:invalid_attributes) {
    {scheduled_for: nil, made_at: 1.day.ago}
  }

  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
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

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'words/show' template)" do
        post :create, params: {word_id: word.id, review: invalid_attributes}, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template('words/show')
      end
    end
  end
end
