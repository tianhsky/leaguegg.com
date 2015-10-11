json.version do
  json.server do
    json.full AppConsts::SERVER_VERSION
  end
  json.android do
    json.full '1.0.0'
    json.major 0
    json.minor 9
    json.patch 4
    json.critical false
  end
  json.ios do
    json.full '0.9.4'
    json.major 0
    json.minor 9
    json.patch 4
    json.critical false
  end
  json.other do
    json.full '0.0.0'
    json.major 0
    json.minor 0
    json.patch 0
    json.critical false
  end
end