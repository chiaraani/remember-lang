class ReviewsController < ApplicationController
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
