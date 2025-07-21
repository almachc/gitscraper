Faraday.default_connection = Faraday.new do |conn|
  conn.request :url_encoded
  conn.response :raise_error
  conn.adapter Faraday.default_adapter
end
