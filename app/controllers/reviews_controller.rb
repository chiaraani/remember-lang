class ReviewsController < ApplicationController
  def index
    @reviews = Review.pending
  end

  def create
    @word = Word.find(params[:word_id])
    @review = @word.reviews.create(review_params)
    redirect_to @word
  end

  def attempt
    @review = Review.pending.first
  end

  private
    def review_params
      params.require(:review).permit(:scheduled_for)
    end
end
