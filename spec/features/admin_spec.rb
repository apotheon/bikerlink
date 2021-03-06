require 'rails_helper'

RSpec.feature 'Admin' do
  before :each do
    @admin = create :biker, :admin
    @biker = create :biker
  end

  context 'with signed-in admin' do
    before :each do
      sign_in @admin
    end

    scenario 'test positive for admin privileges' do
      expect(@admin.admin?).to be_truthy
    end

    scenario 'expect root path to show admin name' do
      visit root_path
      expect(page).to have_text 'admin'
    end

    context 'visiting admin profile' do
      before :each do
        visit biker_path @admin.username
      end

      scenario 'shows link to biker index' do
        expect(page).to have_link 'Biker List', href: bikers_path
      end
    end

    context 'visiting bikers index' do
      before :each do
        visit bikers_path
        @datums = [:username, :active, :admin]
      end

      scenario 'shows biker information table' do
        admin_data = a_to_s @admin, @datums
        biker_data = a_to_s @biker, @datums
        expect(page).to have_text admin_data
        expect(page).to have_text biker_data
      end

      scenario 'shows links to user profiles' do
        [@admin.username, @biker.username].each do |name|
          expect(page).to have_link name, href: biker_path(name)
        end
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
    before :each do
      sign_in @biker
    end

    scenario 'test negative for admin privileges' do
      expect(@biker.admin?).to be_falsey
    end

    scenario 'acts like there is no admin for inactive admin profile' do
      @admin.attributes = { active: false }
      @admin.save

      visit biker_path @admin.username
      expect(page).to have_text 'No Active Biker: "admin"'
    end
  end

  context 'with signed-out visitor' do
    scenario 'rejects biker authorization to see index' do
      visit bikers_path
      expect(page).to have_text 'You are not authorized for that action.'
    end
  end
end
