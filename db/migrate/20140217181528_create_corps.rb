class CreateCorps < ActiveRecord::Migration
  def change
    create_table :corps do |t|
      t.string :name
      t.integer :alliance_id

      t.timestamps
    end
  end
end
