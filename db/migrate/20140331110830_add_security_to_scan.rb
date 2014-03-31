class AddSecurityToScan < ActiveRecord::Migration
  def change
    add_column :scans, :security, :integer
    remove_column :scans, :public
    remove_column :scans, :private
    remove_column :scans, :secure
    remove_column :scans, :alliance_only
    remove_column :scans, :corp_only
  end
end
