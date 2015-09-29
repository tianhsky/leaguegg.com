module Utils
  module JsonParser
    def self.underscoreize(json)
      return nil if json.blank?
      if json.is_a?(Hash)
        r = {}
        json.each do |k, v|
          r["#{k.to_s.underscore}"] = self.underscoreize(v)
        end
        return r
      elsif json.is_a?(Array)
        r = []
        json.each do |v|
          r << self.underscoreize(v)
        end
        return r
      else
        return json
      end
    end

    def self.clone_to(attrs, from_json, to_json)
      attrs.each do |attribute|
        to_json[attribute] = from_json[attribute]
      end
      to_json
    end
  end
end