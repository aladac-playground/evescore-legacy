json.array!(@corps) do |corp|
  json.extract! corp, :id
  json.url corp_url(corp, format: :json)
end
