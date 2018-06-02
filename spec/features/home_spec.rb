require 'rails_helper'

RSpec.feature 'Home' do
  context 'when a user visits the home page' do
    before :each do
      visit '/'
    end

    scenario 'identify the site' do
      expect(page).to have_text 'Biker Link'
    end

    scenario 'explain the site' do
      expect(page).to have_text 'connecting riders online'
    end
  end
end
