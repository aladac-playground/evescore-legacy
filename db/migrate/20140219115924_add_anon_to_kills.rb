class AddAnonToKills < ActiveRecord::Migration
  def change
    add_column :kills, :anon, :boolean
  end
end
