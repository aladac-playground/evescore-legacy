json.array!(@chars) do |char|
  json.extract! char, :id
  json.url char_url(char, format: :json)
end
