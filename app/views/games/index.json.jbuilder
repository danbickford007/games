json.array!(@games) do |game|
  json.extract! game, :players, :score
  json.url game_url(game, format: :json)
end
