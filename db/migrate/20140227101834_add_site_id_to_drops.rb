class AddSiteIdToDrops < ActiveRecord::Migration
  def change
    add_column :drops, :site_id, :integer
  end
end
