require 'rails_helper'

RSpec.feature 'Profile' do
  before :each do
    @alert_inactive = 'No Active Biker:'
  end

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

      scenario 'does not show inactive account alert' do
        expect(page).to_not have_text 'This account is inactive.'
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

        new_description = '#### I do not have much to say.'

        fill_in 'Description', with: new_description
        click_button 'Update'

        visit biker_path @biker
        expect(page).to have_css 'h4', text: 'I do not have much to say.'
      end

      scenario 'shows inactive profile to biker' do
        visit biker_path @biker
        expect(page).to have_text @biker.description
        expect(page).to have_text 'This account is inactive.'
        expect(page).to have_text 'Ask "apotheon" in IRC to activate it.'
      end

      scenario 'provides link to profile' do
        visit root_path
        click_on @biker.username
        expect(page.current_path).to eq biker_path(@biker.username)
      end

      scenario 'allow biker to search for profiles by username' do
        @active = create :biker, :active
        visit root_path

        fill_in 'Username', with: @active.username
        click_button 'Find Biker'
        expect(page).to have_text @active.description
      end
    end

    scenario 'denies visitor access to biker profile' do
      visit biker_path @biker
      expect(page).to have_text %Q{#{@alert_inactive} "#{@biker.username}"}
    end

    scenario 'denies visitor permission to update biker' do
      page.driver.submit :patch, (biker_activate_path @biker), nil
      expect(page).to have_text 'Not Authorized'
      expect(@biker.active).to be_falsey
    end
  end

  scenario 'gracefully handles attempt to view nonexistent profiles' do
    bad_username = 'foobar'
    visit biker_path bad_username
    expect(page).to have_text %Q{#{@alert_inactive} "#{bad_username}"}
  end

  scenario 'disallows unregistered visitor find-by-username' do
    visit root_path
    expect(page).to_not have_button 'Find Biker'
  end
end
