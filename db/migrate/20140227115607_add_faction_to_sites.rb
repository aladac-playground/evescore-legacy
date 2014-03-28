class AddFactionToSites < ActiveRecord::Migration
  def change
    add_column :sites, :faction, :string
  end
end
