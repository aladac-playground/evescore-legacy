class CreateAllieds < ActiveRecord::Migration
  def change
    create_table :allies do |t|
      t.integer :corp_id
      t.integer :alliance_id

      t.timestamps
    end
  end
end
