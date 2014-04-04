class AddSigGroupIdToSigTypes < ActiveRecord::Migration
  def change
    add_column :sig_types, :sig_group_id, :integer
  end
end
