require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:word) { create(:word)  }
  let(:invalid_attributes) { {scheduled_for: nil, performed_at: 1.day.ago} }

  let(:valid_session) { {} }

  describe "POST #create" do

    context "with valid params" do
      let :route do
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

  describe "GET #perform" do
    let(:route) { get :perform, params: {}, session: valid_session }

    context "when pending reviews" do
      it 'returns a success response' do
        create(:pending_review)
        route
        expect(response).to be_successful
      end
    end
context "when no pending reviews" do
      it 'redirects to root' do
        route
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #update" do
    let(:route) { post :update, params: {review: {passed: true}}, session:valid_session }

    context "when pending reviews" do
      before { $review = create(:pending_review) }

      it "performs a pending review" do
        expect {route}.to change(Review.pending, :count).by(-1)
      end

      it "creates a new review for the same word" do
        expect {route}.to change($review.word.reviews, :count).by(1)
      end

      context "if the review was passed," do
        it "creates a new review which has a longer meantime" do
          route
          expect(Review.last.meantime).to be > $review.meantime
        end
      end

      context "if the review was not passed," do
        it "creates a review for tomorrow" do
          post :update, params: {review: {passed: false}}, session:valid_session
          expect(Review.last.scheduled_for).to match Date.tomorrow
        end
      end

      it "redirects to perform" do
        route
        expect(response).to redirect_to(reviews_perform_path)
      end
    end

    context "when no pending reviews" do
      it 'redirects to root' do
        route
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
