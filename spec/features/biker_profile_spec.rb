require 'rails_helper'

RSpec.feature 'Profile' do
  context 'when a signed out visitor views a biker profile page' do
    before :each do
      @biker = create :biker
      visit biker_path @biker
    end

    scenario 'identify profile by username' do
      expect(page).to have_text 'exemplar'
    end

    scenario 'display profile description' do
      expect(page).to have_text @biker.description
    end
  end

  context 'a signed in biker' do
    before :each do
      @biker = create :biker
      sign_in @biker
      visit edit_biker_registration_path
    end

    scenario 'edits its profile' do
      new_description = 'I do not have much to say.'
      fill_in 'Description', with: new_description
      click_button 'Update'

      visit biker_path @biker
      expect(page).to have_text new_description
    end
  end
end
