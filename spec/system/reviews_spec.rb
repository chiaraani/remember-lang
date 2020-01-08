require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  before do
    driven_by(:rack_test)
    create_list(:pending_review, 3)
  end

  scenario "Performing reviews" do
    visit root_path
    click_on "Do pending reviews"

    2.times do
      expect(page).to have_text('Performing reviews')
      check 'review[passed]'
      click_button
      expect(page).to have_text('Review was performed')
      expect(page).to have_text('continue with the next')
    end

      expect(page).to have_text('Performing reviews')
      click_button
      expect(page).to have_text('Review was performed')
      expect(page).to have_text('There aren\'t more pending reviews')
  end

  scenario "Creating review" do
    visit url_for(Word.first)
    fill_in 'review[scheduled_for]', with: 3.days.after.to_date
    click_button "Create Review"
    expect(page).to have_text(3.days.after.to_date.to_s(:long_ordinal))
  end
end
