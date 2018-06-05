class AddUsernameToBikers < ActiveRecord::Migration
  def change
    add_column :bikers, :username, :string
  end
end
