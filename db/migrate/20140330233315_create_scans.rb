class CreateScans < ActiveRecord::Migration
  def change
    create_table :scans do |t|
      t.string :secure_id
      t.references :char, index: true
      t.references :corp, index: true
      t.boolean :public
      t.boolean :private
      t.boolean :secure
      t.references :alliance, index: true
      t.boolean :corp_only
      t.boolean :alliance_only

      t.timestamps
    end
  end
end
