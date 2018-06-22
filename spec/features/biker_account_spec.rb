require 'rails_helper'

RSpec.feature 'Account' do
  context 'with no pre-existing accounts' do
    before :each do
      @biker = build :biker
      visit new_biker_registration_path
    end

    scenario 'creating biker account' do
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

    scenario 'changing username' do
      visit edit_biker_registration_path

      fill_in 'Username', with: @new_username
      click_button 'Update'

      expect(@biker.reload.username).to eql @new_username
    end

    scenario 'failing to change password' do
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

    scenario 'changing password' do
      visit edit_biker_registration_path

      fill_in 'Password', with: @new_password
      fill_in 'Confirm Password', with: @new_password
      click_button 'Update'

      expect(page).to have_text 'Account Updated'

      sign_out @biker

      visit new_biker_session_path

      fill_in 'Email', with: @biker.email
      fill_in 'Password', with: @new_password
      click_button 'Submit'

      expect(page).to have_text @biker.username
    end

    scenario 'viewing biker list' do
      @biker.attributes = { active: true }
      @biker.save

      @vroom = create :bike, owner: @biker
      @sheila = create :bike, owner: @admin
      @admin = create :biker, :admin

      visit bikers_path
      expect(page).to have_text "#{@biker.username}\n#{@vroom.name}"
      expect(page).to_not have_text "#{@admin.username}\n#{@sheila.name}"

      ['Active?', 'Admin?', 'Update'].each do |colname|
        expect(page).to_not have_text colname
      end
    end
  end
end
