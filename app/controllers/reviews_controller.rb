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

  def perform
    if Review.pending.count > 0
      @review = Review.pending.first
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'There are no pending reviews.' }
      end
    end
  end

  private
  def review_params
    params.require(:review).permit(:scheduled_for)
  end
end
