require 'rails_helper'

RSpec.feature 'Admin' do
  before :each do
    @biker = create :biker
    sign_in @biker
  end

  context 'with signed-in admin' do
    before :each do
      @admin = create :biker, :admin
      sign_in @admin
    end

    scenario 'test positive for admin privileges' do
      expect(@admin.admin?).to be_truthy
    end

    scenario 'expect root path to show admin name' do
      visit root_path
      expect(page).to have_text 'admin'
    end

    context 'visiting bikers index' do
      before :each do
        visit bikers_path
        @datums = [:username, :active, :admin]
      end

      scenario 'show biker information table' do
        admin_data = a_to_s @admin, @datums
        biker_data = a_to_s @biker, @datums
        expect(page).to have_text admin_data
        expect(page).to have_text biker_data
      end

      scenario 'activating a biker' do
        click_on 'Activate'
        expect(@biker.reload.active).to be_truthy
      end

      scenario 'deactivating a biker' do
        click_on 'Deactivate'
        expect(@admin.reload.active).to be_falsey
      end

      scenario 'promoting a biker' do
        click_on 'Promote'
        expect(@biker.reload.admin).to be_truthy
      end

      scenario 'demoting a biker' do
        click_on 'Demote'
        expect(@admin.reload.admin).to be_falsey
      end
    end
  end

  context 'with signed-in non-admin biker' do
    scenario 'test negative for admin privileges' do
      expect(@biker.admin?).to be_falsey
    end

    context 'visiting bikers index' do
      before :each do
        visit bikers_path
      end

      scenario 'rejects biker authorization to see index' do
        expect(page).to have_text 'You are not authorized for that action.'
      end
    end
  end
end
