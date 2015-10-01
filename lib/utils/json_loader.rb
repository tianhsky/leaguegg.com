module Utils
  module JsonLoader
    def self.read_from_file(path)
      str = File.read(path)
      str.gsub!(/([\w]+):/, '"\1":')
      json = JSON.parse(str)
      Utils::JsonParser.underscoreize(json)
    end
  end
end