class ReviewsController < ApplicationController

  def index
    Review.pending.arrange
    @reviews = Review.pending
  end

  def create
    @word = Word.find(params[:word_id])
    @review = @word.reviews.new(review_params.permit(:scheduled_for))

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
    unless Review.pending.count > 0
      redirect_to root_path, notice: "Review was performed successfully. There aren't more pending reviews. You passed #{Review.passed_today.count} / #{Review.performed_today.count}."
    end

    @review = Review.pending.first
  end

  def update
    @review = Review.pending.find(params[:id])
    @passed = params['review']['passed'] == "1" ? true : false
    @review.perform(@passed)

    @review.word.create_next_review
    @review.word.should_postpone unless @passed

    redirect_to({ action: 'perform' }, notice: "Review was performed successfully. If you have time, continue with the next review.")
  end

  private
  def review_params
    params.require(:review)
  end
end
