# Services related to current game, fetch live game status from riot or cache
module GameService

  module Factory

    def self.build_game_hash(game, region)
      region.upcase!
      teams = game['participants'].group_by{|x|x['team_id']}
      r = Utils::JsonParser.clone_to([
        'game_id', 'map_id', 'game_mode', 'game_type', 'game_queue_config_id',
        'platform_id', 'game_length'
      ],game,{})
      r['region'] = region
      r['observer_encryption_key'] = game['observers'] ? game['observers']['encryption_key'] : nil,
      r['started_at'] = game['game_start_time']
      r['teams'] = teams.map{|k,v|build_team_hash(k,v,(game['banned_champions']||[]).select{|x|x['team_id']==k})}
      r
    end

    def self.build_team_hash(team_id, participants, bans)
      bans.each{|b|b.delete('team_id')}
      participants.each{|p|p.delete('team_id')}

      {
        'team_id' => team_id,
        'banned_champions' => bans,
        'participants' => participants
      }
    end

  end

end