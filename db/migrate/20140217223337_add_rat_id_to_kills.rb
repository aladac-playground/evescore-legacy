class AddRatIdToKills < ActiveRecord::Migration
  def change
    add_column :kills, :rat_id, :integer
  end
end
