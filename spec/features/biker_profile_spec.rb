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
  end
end
