class AddKeyIdToChar < ActiveRecord::Migration
  def change
    add_column :chars, :key_id, :integer
  end
end
