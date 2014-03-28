json.array!(@rats) do |rat|
  json.extract! rat, :id
  json.url rat_url(rat, format: :json)
end
