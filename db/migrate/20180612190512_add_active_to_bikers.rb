class AddActiveToBikers < ActiveRecord::Migration
  def change
    add_column :bikers, :active, :boolean, default: false
  end
end
