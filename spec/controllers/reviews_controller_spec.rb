require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:word) { create(:word)  }
  let(:invalid_attributes) { {scheduled_for: nil, performed_at: 1.day.ago} }

  let(:valid_session) { {} }

  describe "GET #perform" do
    let(:route) { get :index, params: {}, session: valid_session }

    it 'returns a success response' do
      route
      expect(response).to be_successful
    end

    context "when too many pending reviews" do
      it 'arranges the reviews for some other date' do
        create_list(:pending_review, Remember::MAX_PER_DAY + 1)
        expect {route}.to change(Review.pending, :count).by -1
      end
    end
  end

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
    let(:review) { create(:pending_review) }
    let(:route) { post :update, params: {id: review.id, review: {passed: 1}}, session: valid_session }

    it "performs a pending review" do
      review
      expect {route}.to change(Review.pending, :count).by(-1)
      expect(review.reload.performed_at.to_i).to eq DateTime.now.to_i
    end

    it "creates a new review for the same word" do
      expect {route}.to change(review.word.reviews, :count).by(1)
    end

    context "if the review was passed," do
      before { route }

      it { expect(review.reload.passed).to be true }

      it "creates a new review which has a longer waiting time" do
        expect(Review.last.waiting_time).to be > review.waiting_time
      end
    end

    context "if the review was not passed," do
      before do
        review.word.definers.create(attributes_for :word)
        post :update, params: {id: review.id, review: {passed: false}}, session: valid_session 
      end

      it { expect(review.reload.passed).to be false }

      it "creates a review for tomorrow" do
        expect(Review.last.scheduled_for).to match Date.tomorrow
      end

      it "executes word's method 'should_postpone'" do
        expect(review.reload.word.postpone).to be_truthy
      end
    end

    it "redirects to perform" do
      route
      expect(response).to redirect_to(reviews_perform_path)
    end
  end
end
