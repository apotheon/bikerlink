class AddAdminToBikers < ActiveRecord::Migration
  def change
    add_column :bikers, :admin, :boolean, default: false
  end
end
