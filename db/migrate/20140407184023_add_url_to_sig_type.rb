class AddUrlToSigType < ActiveRecord::Migration
  def change
    add_column :sig_types, :url, :string
  end
end
