require 'rails_helper'

RSpec.feature 'Bike' do
  scenario 'identify one owner for a bike' do
    biker = create :biker
    bike = create :bike, owner_id: biker.id
    expect(bike.owner.username).to eq biker.username
  end

  context 'with an owner of multiple bikes' do
    before :each do
      @vroom = create :bike
      @sheila = create :bike, :sheila, owner_id: @vroom.owner_id
    end

    scenario 'yields several bikes for owner' do
      expect(@vroom.owner.bikes.size).to eq 2
      expect(@vroom.owner.bikes.first.name).to eq @vroom.name
      expect(@vroom.owner.bikes.last.name).to eq @sheila.name
    end

    scenario 'allows owner to edit a bike' do
      new_name = 'VroomVroom'
      new_desc = 'This bike is so fast the Vrooms collided.'
      visit edit_bike_path @vroom

      fill_in 'Name', with: new_name
      fill_in 'Description', with: new_desc
      click_on 'Submit'

      expect(page.current_path).to eq bike_path @vroom
      expect(page).to have_text new_name
      expect(page).to have_text new_desc
    end

    scenario 'shows owner link to edit bike from bike page' do
      sign_in @sheila.owner
      visit bike_path @sheila

      click_on "Edit #{@sheila.name}"
      expect(page.current_path).to eq edit_bike_path @sheila
    end

    scenario 'links to bikes from biker page' do
      @vroom.owner.attributes = { active: true }
      @vroom.owner.save

      visit biker_path @vroom.owner.reload
      click_on @vroom.name
      expect(page.current_path).to eq bike_path @vroom

      visit biker_path @sheila.owner.reload
      click_on @sheila.name
      expect(page.current_path).to eq bike_path @sheila
    end
  end

  context 'with an existing biker' do
    before :each do
      @bikename = 'Gristle'
      @img = 'gristle_34_embed.jpg'
      @owner = create :biker
      sign_in @owner
    end

    scenario 'gives owner a link to add a bike' do
      visit biker_path @owner
      click_on 'Add Bike'
      expect(page.current_path).to eql new_bike_path
    end

    context 'when visiting bike creation page' do
      before do
        visit new_bike_path
      end

      scenario 'shows appropriate page content' do
        expect(page).to have_text 'Add Bike'
      end

      scenario 'lets biker create a bike without image' do
        fill_in 'Name', with: @bikename
        click_button 'Submit'

        expect(page.current_path).to eql edit_bike_path @owner.bikes.first
        expect(@owner.reload.bikes.first.name).to eql @bikename
      end

      scenario 'lets biker create a bike with image' do
        fill_in 'Name', with: @bikename
        attach_file 'Bike Pic', fixture_file(@img)
        click_button 'Submit'

        visit bike_path @owner.reload.bikes.first
      end
    end
  end
end
