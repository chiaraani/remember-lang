class Words::DefinersController < ApplicationController
  before_action :set_word

  # GET /words/1/definers
  def index
    @words = @word.definers
  end

  # POST /words/1/definers
  def create
    new_definer = word_params['new_definer']
    respond_to do |format|
      if @word.add_definer(new_definer)
        @word.should_postpone
        format.html { redirect_to word_definers_path(@word), notice: "New definer was successfully added to word." }
        format.json { render :index, status: :ok, location: @word }
      else
        format.html { render :index }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1/definers/2
  def destroy
    @definer = @word.definers.find(params[:id])
    @word.definers.destroy @definer
    @word.should_postpone
    redirect_to word_definers_path(@word), notice: 'Word was successfully deleted as a definer of word.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:word_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:new_definer)
    end
end
