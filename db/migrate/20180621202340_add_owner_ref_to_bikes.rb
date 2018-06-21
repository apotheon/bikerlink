class AddOwnerRefToBikes < ActiveRecord::Migration
  def change
    add_column :bikes, :owner_id, :integer, index: true
    add_foreign_key :bikes, :bikers, column: :owner_id
  end
end
