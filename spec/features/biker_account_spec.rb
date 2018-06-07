require 'rails_helper'

RSpec.feature 'Account' do
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
