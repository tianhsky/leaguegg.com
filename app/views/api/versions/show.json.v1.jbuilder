json.version do
  json.full @version.to_s
  json.major @version.major
  json.minor @version.minor
  json.patch @version.patch
end