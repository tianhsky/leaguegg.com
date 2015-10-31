module SummonerStats
  class PlayerRole
    include Mongoid::Document
    include TimeTrackable

    # Fields
    field :lane, type: String
    field :role, type: String
    field :games, type: Integer
    field :player_role, type: String

    # Relations
    embedded_in :summoner_stat, class_name: 'SummonerStat'

    # Validations

    # Callbacks
    before_validation :sanitize_attrs
    before_validation :set_player_role

    def set_player_role
      self.player_role = self.class.get_player_role(self.role, self.lane)
    end

    def self.get_player_role(role, lane)
      player_role = nil
      if role
        if role.include?('SUPPORT')
          player_role = 'SUPPORT'
        else
          if lane == 'TOP'
            player_role = 'TOP'
          elsif lane == 'MID' || lane == 'MIDDLE'
            player_role = 'MID'
          elsif lane == 'BOTTOM'
            player_role = 'ADC'
          elsif lane == 'JUNGLE'
            player_role = 'JUNGLE'
          else
          end
        end
      end
      player_role = 'NONE' if player_role.blank?
      player_role
    end

    def sanitize_attrs
      self.lane.try(:upcase!)
      self.role.try(:upcase!)
    end

  end
end