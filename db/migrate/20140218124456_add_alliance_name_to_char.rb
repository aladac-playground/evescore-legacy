class AddAllianceNameToChar < ActiveRecord::Migration
  def change
    add_column :chars, :alliance_name, :string
  end
end
