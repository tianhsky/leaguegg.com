module Consts

  module Mastery

    @lock = Mutex.new

    def self.find_by_id(id)
      setup
      @data[id.to_i] || {}
    end

    def self.find_by_name(name)
      setup
      found = @data.find{|id,v|v['name'].downcase == name.downcase}
      found ? found[1] : {}
    end

    def self.setup
      unless @data
        @lock.synchronize do
          json_file_path = 'app/models/consts/data/masteries.json'
          @json ||= Utils::JsonLoader.read_from_file(json_file_path).with_indifferent_access
          @data ||= load_data
        end
      end
    end

    def self.load_data
      r = {}
      @json['data'].each do |name, value|
        r["#{value['id']}".to_i] = {
          "id" => value['id'],
          "name" => value['name'],
          "description" => value['description']
        }
      end
      r.with_indifferent_access
    end

  end

end