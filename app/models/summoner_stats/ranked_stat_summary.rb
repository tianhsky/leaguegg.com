module SummonerStats
  class RankedStatSummary
    include Mongoid::Document
    include TimeTrackable

    # Fields
    field :riot_updated_at, type: Integer

    field :total_sessions_played, type: Integer
    field :total_sessions_lost, type: Integer
    field :total_sessions_won, type: Integer
    field :total_champion_kills, type: Integer
    field :killing_spree, type: Integer
    field :total_damage_dealt, type: Integer
    field :total_damage_taken, type: Integer
    field :most_champion_kills_per_session, type: Integer
    field :total_minion_kills, type: Integer
    field :total_double_kills, type: Integer
    field :total_triple_kills, type: Integer
    field :total_quadra_kills, type: Integer
    field :total_penta_kills, type: Integer
    field :total_unreal_kills, type: Integer
    field :total_deaths_per_session, type: Integer
    field :total_gold_earned, type: Integer
    field :most_spells_cast, type: Integer
    field :total_turrets_killed, type: Integer
    field :total_physical_damage_dealt, type: Integer
    field :total_magic_damage_dealt, type: Integer
    field :total_neutral_minions_killed, type: Integer
    field :total_first_blood, type: Integer
    field :total_assists, type: Integer
    field :total_heal, type: Integer
    field :max_largest_killing_spree, type: Integer
    field :max_largest_critical_strike, type: Integer
    field :max_champions_killed, type: Integer
    field :max_num_deaths, type: Integer
    field :max_time_played, type: Integer
    field :max_time_spent_living, type: Integer
    field :normal_games_played, type: Integer
    field :ranked_solo_games_played, type: Integer
    field :ranked_premade_games_played, type: Integer
    field :bot_games_played, type: Integer

    # Relations
    embedded_in :summoner_stat, class_name: 'SummonerStat'

    # Validations

    # Functions

  end
end