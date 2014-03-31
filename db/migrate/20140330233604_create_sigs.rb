class CreateSigs < ActiveRecord::Migration
  def change
    create_table :sigs do |t|
      t.references :scan, index: true
      t.references :char, index: true
      t.references :corp, index: true
      t.references :system, index: true
      t.references :cons, index: true
      t.references :region, index: true
      t.references :alliance, index: true
      t.references :sig_type, index: true
      t.references :sig_group, index: true

      t.timestamps
    end
  end
end
