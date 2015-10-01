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
      if self.role.include?('SUPPORT')
        self.player_role = 'SUPPORT'
      else
        if self.lane == 'TOP'
          self.player_role = 'TOP'
        elsif self.lane == 'MID'
          self.player_role = 'MID'
        elsif self.lane == 'BOTTOM'
          self.player_role = 'ADC'
        elsif self.lane == 'JUNGLE'
          self.player_role = 'JUNGLE'
        else
        end
      end
      self.player_role = 'NONE' if self.player_role.blank?
    end


    def sanitize_attrs
      self.lane.try(:upcase!)
      self.role.try(:upcase!)
    end

  end
end