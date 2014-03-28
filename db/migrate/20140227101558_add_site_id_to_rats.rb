class AddSiteIdToRats < ActiveRecord::Migration
  def change
    add_column :rats, :site_id, :integer
  end
end
