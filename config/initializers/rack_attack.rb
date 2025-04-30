class Rack::Attack
  throttle('req/ip', limit: 2, period: 1.second) do |req|
    req.ip
  end

  self.throttled_response = lambda do |env|
    [429, { 
      'Content-Type' => 'application/json',
      'Retry-After' => (env['rack.attack.match_data'] || {})[:period].to_s
    }, [{
      error: 'Rate limit exceeded. Try again later.'
    }.to_json]]
  end
end
