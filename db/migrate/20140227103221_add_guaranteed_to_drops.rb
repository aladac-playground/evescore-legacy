class AddGuaranteedToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :guaranteed, :boolean
  end
end
