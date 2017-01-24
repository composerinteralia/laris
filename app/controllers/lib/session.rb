class Session
  attr_reader :cookie

  def initialize(req)
    raw_cookie = req.cookies['_laris_session']
    @cookie = raw_cookie ? JSON.parse(raw_cookie) : {}
  end

  def [](key)
    cookie[key]
  end

  def []=(key, val)
    cookie[key] = val
  end

  def store_session(res)
    new_cookie = { path: '/', value: cookie.to_json }
    res.set_cookie('_laris_session', new_cookie)
  end
end
