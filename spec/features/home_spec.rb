require 'rails_helper'

RSpec.feature 'Home' do
  context 'when a user visits the home page' do
    before :each do
      visit root_path
    end

    scenario 'identify the site' do
      expect(page).to have_text 'Biker Link'
    end

    scenario 'explain the site' do
      expect(page).to have_text 'connecting riders online'
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
end
