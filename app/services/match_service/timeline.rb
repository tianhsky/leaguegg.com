module MatchService

  module Timeline

    def self.aggregate(match)
      self._gen_player_role(match)

      self._gen_frames(match)

      self._sort_participants_by_role(match)
    end

    private

    def self._gen_player_role(match)
      match.teams.each do |team|
        team['participants'].each do |p|
          if timeline = p['timeline']
            if timeline['role']
              p['player_role'] = SummonerStats::PlayerRole.get_player_role(timeline['role'], timeline['lane'])
            end
          end
        end
      end
    end

    def self._sort_participants_by_role(match)
      match.teams.each do |team|
        team['participants'].sort_by!{|p| p['player_role']}
      end
    end

    def self._gen_frames(match)
      return if match.timeline.blank?

      # current version
      parser_version = 2

      # check version
      return if match.timeline['parser_version'].to_i == parser_version

      # aggregated stats
      frame_stats_by_participant = {}
      frame_stats_by_team = {}
      1.upto(10).each do |i|
        frame_stats_by_participant["#{i}"] = self._gen_participant_blank_frame_stats
      end
      [100, 200].each do |i|
        frame_stats_by_team["#{i}"] = self._gen_team_blank_frame_stats
      end

      # aggretate events
      match.timeline['frames'].each do |frame| 
        if events = frame['events']
          events.each do |ev|
            et = ev['event_type']
            if et == 'CHAMPION_KILL'
              self._aggregate_champion_kills(ev, frame_stats_by_participant, frame_stats_by_team)
            end
            if et == 'BUILDING_KILL'
              self._aggregate_building_kills(ev, frame_stats_by_participant, frame_stats_by_team)
            end
            if et == 'ELITE_MONSTER_KILL'
              self._aggregate_elite_monster_kills(ev, frame_stats_by_participant, frame_stats_by_team)
            end
            if ['ITEM_PURCHASED', 'ITEM_SOLD', 'ITEM_DESTROYED', 'ITEM_UNDO'].include?(et)
              self._aggregate_item_inventories(ev, frame_stats_by_participant, frame_stats_by_team)
            end
          end
        end
        frame['team_frames'] = frame_stats_by_team.deep_dup
        if participant_frames = frame['participant_frames']
          participant_frames.each do |pf_arr|
            pf_key = pf_arr[0]
            pf = pf_arr[1]
            pf.merge!(frame_stats_by_participant["#{pf_key}"].deep_dup)
          end
        end
      end

      # stamp version
      match.timeline['parser_version'] = parser_version
    end

    # CHAMPION_KILL
    def self._aggregate_champion_kills(ev, frame_stats_p, frame_stats_t)
      killer_id = ev['killer_id']
      if killer_id != 0
        frame_stats_p["#{killer_id}"]['kills']+=1
      end
      victim_id = ev['victim_id']
      if victim_id != 0
        frame_stats_p["#{victim_id}"]['deaths']+=1
      end
      if assisters = ev['assisting_participant_ids']
        assisters.each do |p_id|
          frame_stats_p["#{p_id}"]['assists']+=1
        end
      end
    end

    # BUILDING_KILL
    def self._aggregate_building_kills(ev, frame_stats_p, frame_stats_t)
      team_id = ev['team_id']
      team_stats = frame_stats_t["#{team_id}"]
      if team_stats
        team_stats['building_kills']+=1
      end
      killer_id = ev['killer_id']
      if killer_id != 0
        frame_stats_p["#{killer_id}"]['building_kills']+=1
      end
    end

    # ELITE_MONSTER_KILL
    def self._aggregate_elite_monster_kills(ev, frame_stats_p, frame_stats_t)
      monster_type = ev['monster_type']
      key = nil
      if monster_type == 'DRAGON'
        key = 'dragon_kills'
      else
        key = 'baron_kills'
      end
      killer_id = ev['killer_id']
      if killer_id != 0
        killer_team_id = self._get_team_id_for_participant_id(killer_id)
        frame_stats_t["#{killer_team_id}"][key]+=1
        frame_stats_p["#{killer_id}"][key]+=1
      end
    end

    # ITEM_PURCHASED, ITEM_SOLD, ITEM_DESTROYED, ITEM_UNDO
    def self._aggregate_item_inventories(ev, frame_stats_p, frame_stats_t)
      purchase_type = ev['event_type']
      if purchase_type == 'ITEM_PURCHASED'
        item_id = ev['item_id']
        frame_stats_p["#{ev['participant_id']}"]['items'] << item_id
      elsif ['ITEM_SOLD', 'ITEM_DESTROYED'].include?(purchase_type)
        item_id = ev['item_id']
        if ev['participant_id'] != 0
          if index = frame_stats_p["#{ev['participant_id']}"]['items'].find_index(item_id)
            frame_stats_p["#{ev['participant_id']}"]['items'].delete_at(index)
          end
        end
      elsif purchase_type == 'ITEM_UNDO'
        from_item_id = ev['item_before']
        to_item_id = ev['item_after']
        if from_item_id != 0
          index = frame_stats_p["#{ev['participant_id']}"]['items'].find_index(from_item_id)
          frame_stats_p["#{ev['participant_id']}"]['items'].delete_at(index)
        end
        if to_item_id != 0
          frame_stats_p["#{ev['participant_id']}"]['items'] << to_item_id
        end
      else
      end
    end

    def self._get_team_id_for_participant_id(participant_id)
      if participant_id.to_i <= 5
        100
      else
        200
      end
    end

    def self._gen_team_blank_frame_stats
      {
        'building_kills' => 0,
        'baron_kills' => 0,
        'dragon_kills' => 0
      }
    end

    def self._gen_participant_blank_frame_stats
      # 'current_gold' => 0,
      # 'total_gold' => 0,
      # 'level' => 1,
      # 'xp' => 0,
      # 'minions_killed' => 0,
      # 'jungle_minions_killed' => 0,
      stats = {
        'building_kills' => 0,
        'baron_kills' => 0,
        'dragon_kills' => 0,
        'kills' => 0,
        'deaths' => 0,
        'assists' => 0,
        'items' => [
        ]
      }
      stats
    end

  end

end