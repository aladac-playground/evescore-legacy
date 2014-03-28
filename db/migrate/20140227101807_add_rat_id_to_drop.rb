class AddRatIdToDrop < ActiveRecord::Migration
  def change
    add_column :drops, :rat_id, :integer
  end
end
