require 'rails_helper'

RSpec.feature 'Profile' do
  context 'when a signed in user visits its profile' do
    before :each do
      @biker = create :biker
      sign_in @biker
      visit biker_path @biker
    end

    scenario 'identify profile by username' do
      expect(page).to have_text 'exemplar'
    end
  end
end
