class AddShortNameToAlliance < ActiveRecord::Migration
  def change
    add_column :alliances, :short_name, :string
  end
end
