class AddBikePicToBikes < ActiveRecord::Migration
  def change
    add_column :bikes, :bikepic, :oid
  end
end
