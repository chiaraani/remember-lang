require 'rails_helper'

RSpec.describe "Words", type: :system do
  before do
    driven_by(:rack_test)
    create(:word, spelling: 'fish')
  end

  scenario "Visiting words" do
    visit root_path
    click_on "Words"
    expect(page).to have_text('fish')
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
    visit root_path
    click_on "New Word"
    fill_in 'word[spelling]', with: 'white'
    uncheck 'review'
    click_on 'Create Word'
    expect(page).to have_text('successfully created')
    expect(find('h1')).to have_text('white')
    expect(page).to_not have_text(Date.tomorrow)
  end
end
