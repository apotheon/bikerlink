class AddDescriptionToBikers < ActiveRecord::Migration
  def change
    add_column :bikers, :description, :text
  end
end
