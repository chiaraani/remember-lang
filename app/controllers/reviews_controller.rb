class ReviewsController < ApplicationController

  def index
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
      redirect_to root_path, notice: "There aren't more pending reviews. You passed #{Review.passed_today.count} / #{Review.performed_today.count}."
    end

    @review = Review.pending.first
  end

  def update
    @review = Review.pending.find(params[:id])
    @passed = params['review']['passed'] == "1" ? true : false
    @review.perform(@passed)

    scheduled_for = if @passed
      (@review.meantime * 2).round.days.from_now
    else
      Date.tomorrow
    end
    @review.word.reviews.create!(scheduled_for: scheduled_for)

    redirect_to({ action: 'perform' }, notice: "The review was performed successfully. Well done, continue with hard work.")
  end

  private
  def review_params
    params.require(:review)
  end
end
