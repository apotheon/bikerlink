require 'rails_helper'

RSpec.feature 'Bike' do
  scenario 'identify one owner for a bike' do
    @biker = create :biker
    @bike = create :bike, owner_id: @biker.id
    expect(@bike.owner.username).to eq @biker.username
  end

  context 'with existing bikes' do
    before :each do
      @vroom = create :bike
      @sheila = create :bike, :sheila, owner_id: @vroom.owner_id
    end

    scenario 'owner has several bikes' do
      expect(@vroom.owner.bikes.size).to eq 2
      expect(@vroom.owner.bikes.first.name).to eq @vroom.name
      expect(@vroom.owner.bikes.last.name).to eq @sheila.name
    end
  end

  context 'with an existing user' do
    before :each do
      @owner = create :biker
      sign_in @owner
    end

    scenario 'owner creates a bike' do
      bike_name = 'Gristle'
      visit new_bikes_path
      expect(page).to have_text 'Add Bike'

      fill_in 'Name', with: bike_name
      click_button 'Submit'

      expect(page.current_path).to eql edit_bikes_path @owner.bikes.first.name
      expect(@owner.bikes.first.name).to eql bike_name
    end
  end
end
