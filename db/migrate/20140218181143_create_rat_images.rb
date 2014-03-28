class CreateRatImages < ActiveRecord::Migration
  def change
    create_table :rat_images do |t|
      t.integer :rat_id
      t.string :md5
      t.integer :size

      t.timestamps
    end
  end
end
