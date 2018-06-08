require 'rails_helper'

RSpec.feature 'Account' do
  context 'with no pre-existing accounts' do
    before :each do
      @biker = build :biker
      visit new_biker_registration_path
    end

    scenario 'create biker account' do
      expect(Biker.first).to be_nil

      fill_in 'Username', with: @biker.username
      fill_in 'Email', with: @biker.email
      fill_in 'Password', with: @biker.password
      fill_in 'Confirm Password', with: @biker.password
      click_button 'Submit'

      expect(page.current_path).to eql new_biker_session_path
      expect(Biker.first.username).to eql @biker.username
    end
  end

  context 'with a pre-existing account' do
    before :each do
      @new_username = 'example'
      @new_password = 'sakabatosakabato'
      @biker = create :biker
      sign_in @biker
    end

    scenario 'change username' do
      visit edit_biker_registration_path

      fill_in 'Username', with: @new_username
      click_button 'Update'

      expect(@biker.reload.username).to eql @new_username
    end

    scenario 'fail to change password' do
      visit edit_biker_registration_path

      fill_in 'Password', with: @new_password
      click_button 'Update'

      expect(page).to have_text 'Password change failed.'

      visit edit_biker_registration_path

      fill_in 'Password', with: @new_password
      fill_in 'Confirm Password', with: 'gibberish'
      click_button 'Update'

      expect(page).to have_text 'Password change failed.'
    end

    scenario 'change password' do
      visit edit_biker_registration_path

      fill_in 'Password', with: @new_password
      fill_in 'Confirm Password', with: @new_password
      click_button 'Update'

      expect(page).to have_text 'Account Updated'

      visit new_biker_session_path

      fill_in 'Email', with: @biker.email
      fill_in 'Password', with: @new_password
      click_button 'Submit'

      expect(page).to have_text @biker.username
    end
  end
end
