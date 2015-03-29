module HttpService

  HEADERS = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  }
  QUERY = {
    'api_key' => ENV['LOL_API_KEY']
  }

  def self.get(url, opts={})
    opts[:query] ||= {}
    opts[:query].merge!(QUERY)
    opts[:headers] ||= {}
    opts[:headers].merge!(HEADERS)
    resp = HTTParty.get(url, opts)
    raise ActiveRecord::RecordNotFound if resp.response.code == '404'
    JSON.parse resp.body
  end

end