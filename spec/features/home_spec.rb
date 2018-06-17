require 'rails_helper'

RSpec.feature 'Home' do
  context 'when a visitor views the home page' do
    before :each do
      visit root_path
    end

    scenario 'identify the site' do
      expect(page).to have_text 'Biker Link'
      expect(page).to have_text 'connecting riders online'
    end

    scenario 'explain the site' do
      expect(page).to have_text 'Welcome to Biker Link.'
    end

    scenario 'show sign in/up links' do
      expect(page).to have_link 'Sign In', href: '/bikers/sign_in'
      expect(page).to have_link 'Sign Up', href: '/bikers/sign_up'
    end

    context 'while signed in' do
      before :each do
        @biker = create :biker
        sign_in @biker
        visit root_path
      end

      scenario 'show account links' do
        expect(page).to have_text @biker.username
        expect(page).to have_link 'Account Settings', href: '/bikers/edit'
        expect(page).to have_link 'Sign Out', href: '/bikers/sign_out'
      end
    end
  end

  scenario 'site title links to the home page' do
    visit new_biker_registration_path

    click_on 'Biker Link'
    expect(page.current_path).to eq root_path
  end
end
