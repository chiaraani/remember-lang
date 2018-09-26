class ReviewsController < ApplicationController
  def index
    @reviews = Review.pending
  end

  def create
    @word = Word.find(params[:word_id])
    @review = @word.reviews.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @word, notice: 'Review was successfully created.' }
      else
        format.html { render 'words/show' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def make
    @review = Review.pending.first
  end

  private
    def review_params
      params.require(:review).permit(:scheduled_for)
    end
end
