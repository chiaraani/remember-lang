require 'rails_helper'

RSpec.describe "Words", type: :system do
  before { driven_by(:rack_test) }
  let!(:word) { create(:word, spelling: 'fish') }

  scenario "Visiting words" do
    visit root_path
    click_on "Words"
    expect(page).to have_text('fish')
    click_on 'fish'
    expect(find('h1')).to have_text('fish')
  end

  scenario "Creating word" do
    visit root_path
    click_on "New Word"
    fill_in 'word[spelling]', with: 'white'
    click_on 'Create Word'
    expect(page).to have_text('successfully created')
    expect(find('h1')).to have_text('white')
    expect(page).to have_text(Date.tomorrow.to_s(:long_ordinal))
  end

  scenario "Creating word without review" do
    visit root_path
    click_on "New Word"
    fill_in 'word[spelling]', with: 'white'
    uncheck 'review'
    click_on 'Create Word'
    expect(page).to have_text('successfully created')
    expect(find('h1')).to have_text('white')
    expect(page).to_not have_text(Date.tomorrow)    
  end

  scenario "Editing word" do
    visit url_for word
    click_on 'Edit'
    fill_in 'word[spelling]', with: 'salmon'
    click_on 'Update Word'
    expect(page).to have_text('successfully updated')
    expect(find('h1')).to have_text('salmon')
  end

  scenario "Destroying word" do
    visit url_for word
    click_on 'Destroy'
    expect(page).to have_text('successfully destroyed')
    expect(find('h1')).to have_text('Words')
  end

  scenario "Adding definer to word" do
    create(:word, spelling: 'animal')
    visit url_for word
    fill_in 'word[new_definer]', with: 'animal'
    click_on 'Add definer'
    expect(page).to have_text('New definer was successfully added to word')
    expect(page).to have_text('Definers')
    expect(page).to have_text('animal')
  end

  scenario "Deleting definer of word" do
    word.definers << create(:word, spelling: 'animal')
    visit url_for word
    click_on 'Define no longer'
    expect(page).to have_text('Word was successfully deleted as a definer of word.')
    expect(page).to have_text('Definers')
    expect(page).to_not have_text('animal')
  end
end
