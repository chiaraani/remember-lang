class Words::DefinersController < ApplicationController
  before_action :set_word

  # POST /words/1/definers
  def create
    new_definer = word_params['new_definer']
    respond_to do |format|
      if @word.add_definer(new_definer)
        format.html { redirect_to @word, notice: "New definer was successfully added to word." }
        format.json { render 'words/show', status: :ok, location: @word }
      else
        format.html { render 'words/show' }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
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
