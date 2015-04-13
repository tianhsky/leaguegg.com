module Consts

  module GameQueue

    @lock = Mutex.new

    def self.find_by_id(id)
      setup
      @data[id.to_i] || {}
    end

    def self.setup
      unless @data
        @lock.synchronize do
          json_file_path = 'app/models/consts/data/game_queues.json'
          @json ||= Utils::JsonLoader.read_from_file(json_file_path)
          @data ||= load_data
        end
      end
    end

    def self.load_data
      r = {}
      @json.each do |q|
        r["#{q['id']}".to_i] = {
          "id" => q['id'],
          "name" => q['name'],
          "type" => q['type']
        }
      end
      r.with_indifferent_access
    end

  end

end