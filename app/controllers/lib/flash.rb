class Flash
  attr_reader :stale_cookie, :fresh_cookie

  def initialize(req)
    raw_cookie = req.cookies['_rails_lite_app_flash']
    @stale_cookie = raw_cookie ? JSON.parse(raw_cookie) : {}
    @fresh_cookie = {}
    @persistent = true
  end

  def persistent?
    @persistent
  end

  def now
    @persistent = false
    self
  end

  def [](key)
    fresh_cookie.merge(stale_cookie)[key]
  end

  def []=(key, val)
    if persistent?
      fresh_cookie[key] = val
    else
      stale_cookie[key] = val
    end

    @persistent = true
    val
  end

  def store_flash(res)
    new_cookie = { path: '/', value: fresh_cookie.to_json }
    res.set_cookie('_rails_lite_app_flash', new_cookie)
  end
end
