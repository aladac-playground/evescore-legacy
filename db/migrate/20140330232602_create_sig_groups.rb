class CreateSigGroups < ActiveRecord::Migration
  def change
    create_table :sig_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
