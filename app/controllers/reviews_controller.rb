class ReviewsController < ApplicationController
  def index
    @reviews = Review.where("expires_at <= ?", Date.today)
  end

  def create
    @word = Word.find(params[:word_id])
    @review = @word.reviews.create(review_params)
    redirect_to @word
  end

  private
    def review_params
      params.require(:review).permit(:expires_at)
    end
end
