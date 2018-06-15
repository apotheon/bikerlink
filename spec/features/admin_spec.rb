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
      end

      scenario 'show biker information table' do
        @a = [@admin.username, @admin.active, @admin.admin.to_s]
        @b = [@biker.username, @biker.active, @biker.admin.to_s]
        expect(page).to have_text @a.join ' '
        expect(page).to have_text @b.join ' '
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
        expect(page).to_not have_text 'admin'
      end
    end
  end
end
