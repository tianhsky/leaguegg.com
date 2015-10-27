json.winner stat['winner']
json.champ_level stat['champ_level']

json.item0 do
  json.partial! 'api/consts/item', {item_id: stat['item0']}
end
json.item1 do
  json.partial! 'api/consts/item', {item_id: stat['item1']}
end
json.item2 do
  json.partial! 'api/consts/item', {item_id: stat['item2']}
end
json.item3 do
  json.partial! 'api/consts/item', {item_id: stat['item3']}
end
json.item4 do
  json.partial! 'api/consts/item', {item_id: stat['item4']}
end
json.item5 do
  json.partial! 'api/consts/item', {item_id: stat['item5']}
end
json.item6 do
  json.partial! 'api/consts/item', {item_id: stat['item6']}
end

json.kills stat['kills']
json.double_kills stat['double_kills']
json.triple_kills stat['triple_kills']
json.quadra_kills stat['quadra_kills']
json.penta_kills stat['penta_kills']
json.unreal_kills stat['unreal_kills']
json.largest_killing_spree stat['largest_killing_spree']
json.deaths stat['deaths']
json.assists stat['assists']
json.total_damage_dealt stat['total_damage_dealt']
json.total_damage_dealt_to_champions stat['total_damage_dealt_to_champions']
json.total_damage_taken stat['total_damage_taken']
json.largest_critical_strike stat['largest_critical_strike']
json.total_heal stat['total_heal']
json.minions_killed stat['minions_killed']
json.neutral_minions_killed stat['neutral_minions_killed']
json.neutral_minions_killed_team_jungle stat['neutral_minions_killed_team_jungle']
json.neutral_minions_killed_enemy_jungle stat['neutral_minions_killed_enemy_jungle']
json.gold_earned stat['gold_earned']
json.gold_spent stat['gold_spent']
json.combat_player_score stat['combat_player_score']
json.objective_player_score stat['objective_player_score']
json.total_player_score stat['total_player_score']
json.total_score_rank stat['total_score_rank']
json.magic_damage_dealt_to_champions stat['magic_damage_dealt_to_champions']
json.physical_damage_dealt_to_champions stat['physical_damage_dealt_to_champions']
json.true_damage_dealt_to_champions stat['true_damage_dealt_to_champions']
json.vision_wards_bought_in_game stat['vision_wards_bought_in_game']
json.sight_wards_bought_in_game stat['sight_wards_bought_in_game']
json.magic_damage_dealt stat['magic_damage_dealt']
json.physical_damage_dealt stat['physical_damage_dealt']
json.true_damage_dealt stat['true_damage_dealt']
json.magic_damage_taken stat['magic_damage_taken']
json.physical_damage_taken stat['physical_damage_taken']
json.true_damage_taken stat['true_damage_taken']
json.first_blood_kill stat['first_blood_kill']
json.first_blood_assist stat['first_blood_assist']
json.first_tower_kill stat['first_tower_kill']
json.first_tower_assist stat['first_tower_assist']
json.first_inhibitor_kill stat['first_inhibitor_kill']
json.first_inhibitor_assist stat['first_inhibitor_assist']
json.inhibitor_kills stat['inhibitor_kills']
json.tower_kills stat['tower_kills']
json.wards_placed stat['wards_placed']
json.wards_killed stat['wards_killed']
json.largest_multi_kill stat['largest_multi_kill']
json.killing_sprees stat['killing_sprees']
json.total_units_healed stat['total_units_healed']
json.total_time_crowd_control_dealt stat['total_time_crowd_control_dealt']
