class AddAllianceIdToChar < ActiveRecord::Migration
  def change
    add_column :chars, :alliance_id, :integer
  end
end
