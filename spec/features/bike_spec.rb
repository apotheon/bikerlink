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
      expect(@vroom.owner.bikes.first.name).to eq 'Vroom Vroom'
      expect(@vroom.owner.bikes.last.name).to eq 'Sheila'
    end
  end
end
