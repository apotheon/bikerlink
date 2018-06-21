require 'rails_helper'

RSpec.feature 'Bike' do
  before :each do
    @biker = create :biker
    @bike = create :bike, owner_id: @biker.id
  end

  scenario 'identify one owner for a bike' do
    expect(@bike.owner.username).to eq @biker.username
  end
end
