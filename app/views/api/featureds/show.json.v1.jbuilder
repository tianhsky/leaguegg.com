json.featured_games @featured['game_list'] do |game|
  json.partial! 'game', {game: game}
end