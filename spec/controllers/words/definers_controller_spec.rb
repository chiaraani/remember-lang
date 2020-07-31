require 'rails_helper'

RSpec.describe Words::DefinersController, type: :controller do
  let(:word) { create(:word) }
  let(:valid_session) { {} }

  describe 'POST #create' do
    context "with valid params" do
      before do
        create(:word, spelling: 'apple')
        post :create, params: {word_id: word.to_param, word: {new_definer: 'apple'}}, session: valid_session
      end

      it "adds the new definer" do
        word.reload
        expect(word.definers.pluck(:spelling)).to include('apple')
      end

      it("redirects to the word") { expect(response).to redirect_to(word) }
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the word 'show' template)" do
        post :create, params: {word_id: word.to_param, word: {new_definer: ''}}, session: valid_session
        expect(response).to be_successful
        expect(response).to render_template('words/show')
      end
    end
  end
end
