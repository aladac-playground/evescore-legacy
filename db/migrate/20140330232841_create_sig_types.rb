class CreateSigTypes < ActiveRecord::Migration
  def change
    create_table :sig_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
