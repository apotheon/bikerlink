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

      scenario 'show bikers by name' do
        expect(page).to have_text 'exemplar'
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
