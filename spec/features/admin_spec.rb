require 'rails_helper'

RSpec.feature 'Admin' do
  context 'with signed-in admin' do
    before :each do
      @admin = create :biker, :admin
      sign_in @admin
    end

    scenario 'test positive for admin privileges' do
      expect(@admin.admin?).to be_truthy
    end
  end

  context 'with signed-in non-admin biker' do
    before :each do
      @biker = create :biker
      sign_in @biker
    end

    scenario 'test negative for admin privileges' do
      expect(@biker.admin?).to be_falsey
    end
  end
end
