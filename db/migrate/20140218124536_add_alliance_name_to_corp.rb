class AddAllianceNameToCorp < ActiveRecord::Migration
  def change
    add_column :corps, :alliance_name, :string
  end
end
