module HttpService

  HEADERS = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  }
  QUERY = {
    'api_key' => ENV['LOL_API_KEY']
  }

  def self.get_api_key
    @api_keys ||= ENV['LOL_API_KEYS'].split(',')
    @key_index ||= 0
    if @key_index >= @api_keys.count-1
      @key_index = 0
    else
      @key_index += 1
    end
    @api_keys[@key_index]
  end

  def self.get_api_key_param
    {'api_key' => get_api_key}
  end

  def self.get(url, region, opts={})
    url = URI::encode(url)
    opts[:query] ||= {}
    opts[:query].merge!(get_api_key_param)
    opts[:headers] ||= {}
    opts[:headers].merge!(HEADERS)

    key = region.try(:downcase) || 'all'
    resp = nil
    
    AppService::RIOT_THROTTLE.exec_within_threshold key, threshold: 3000, interval: 10 do
      resp = HTTParty.get(url, opts)
      AppService::RIOT_THROTTLE.add(key)
    end

    status_code = resp.response.code.to_i
    raise Errors::RateLimitError.new if status_code == 429
    raise Errors::NotFoundError.new if status_code == 404

    json = JSON.parse resp.body
    Utils::JsonParser.underscoreize(json)
  end

end