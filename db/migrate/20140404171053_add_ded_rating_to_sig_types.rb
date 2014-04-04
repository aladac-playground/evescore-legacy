class AddDedRatingToSigTypes < ActiveRecord::Migration
  def change
    add_column :sig_types, :ded_rating, :integer
  end
end
