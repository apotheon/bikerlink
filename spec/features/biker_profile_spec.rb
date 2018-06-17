require 'rails_helper'

RSpec.feature 'Profile' do
  context 'with an active biker' do
    before :each do
      @active = create :biker, :active
    end

    context 'when a visitor views a biker profile page' do
      before :each do
        visit biker_path @active 
      end

      scenario 'identifies profile by username' do
        expect(page).to have_text 'exemplar'
      end

      scenario 'displays profile description' do
        expect(page).to have_text @active.description
      end
    end
  end

  context 'with an inactive biker' do
    before :each do
      @biker = create :biker
    end

    context 'with the biker signed in' do
      before :each do
        sign_in @biker
      end

      scenario 'allows profile edits' do
        visit edit_biker_registration_path

        new_description = 'I do not have much to say.'

        fill_in 'Description', with: new_description
        click_button 'Update'

        visit biker_path @biker
        expect(page).to have_text new_description
      end

      scenario 'shows inactive profile to biker' do
        visit biker_path @biker
        expect(page).to have_text @biker.description
      end
    end

    scenario 'denies visitor access to biker profile' do
      visit biker_path @biker
      expect(page).to have_text %Q{No Active Biker: "#{@biker.username}"}
    end
  end
end
