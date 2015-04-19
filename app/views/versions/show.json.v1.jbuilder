json.version do
  json.api do
    json.full @version.to_s
    json.major @version.major
    json.minor @version.minor
    json.patch @version.patch
  end
  json.android do
    json.full 'v0.9.4'
    json.major 0
    json.minor 9
    json.patch 4
    json.critical false
  end
  json.ios do
    json.full 'v0.9.4'
    json.major 0
    json.minor 9
    json.patch 4
    json.critical false
  end
end