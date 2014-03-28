class Array
  def wallet_import
    (self.select { |r| [ 33, 34, 85, 99 ].include? r["refTypeID"].to_i }).each do |row|
      next if row["amount"].to_i == 0
      record = WalletRecord.parse(row)
      if row["refTypeID"] == "85"
        rats = WalletRecord.parse_reason(row)
        rats.each_pair do |rat_id, rat_amount|
          # => Kill(id: integer, ts: datetime, rat_name: string, rat_type: string, rat_amount: integer, char_name: string, corp_name: string, alliance_name: string, char_id: integer, corp_id: integer, alliance_id: integer, wallet_record_id: integer, created_at: datetime, updated_at: datetime, rat_id: integer, user_id: integer, anon: boolean)
          rat = Rat.find(rat_id)
          record.kills.create(
            ts: record.ts,
            rat_name: rat.name,
            rat_type: rat.rat_type,
            rat_amount: rat_amount,
            char_name: record.char_name,
            corp_name: record.corp_name,
            alliance_name: record.alliance_name,
            char_id: record.char_id,
            corp_id: record.corp_id,
            alliance_id: record.alliance_id,
            wallet_record_id: record.id,
            rat_id: rat_id,
            user_id: record.user_id,
            anon: record.anon
          )
        end
      end
    end
  end
end
