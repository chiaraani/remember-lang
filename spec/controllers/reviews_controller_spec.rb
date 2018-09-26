require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:word) {
    create(:word)
  }
  let(:invalid_attributes) {
    {scheduled_for: nil, made_at: 1.day.ago}
  }

  let(:valid_session) { {} }

  describe "POST #create" do

    context "with valid params" do
      def route
        post :create,
        params: {word_id: word.id, review: attributes_for(:review)},
        session: valid_session
      end
      it "creates a new review" do
        expect {route}.to change(Review, :count).by(1)
      end

      it "redirects to the created review's word" do
        route
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
=begin
  describe "GET #make" do
    context "when pending reviews" do
      before { create_list(:pending_review, 2) }
      it 'returns a success response
=end
end
