require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'

class FlashController < ControllerBase
  def flash_me
    flash['persist'] = "This message should persist exactly once"
    flash.now['die'] = "This message should not persist"
    render :show
  end

  def show
    render :show
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/flash$"), FlashController, :flash_me
  get Regexp.new("^/$"), FlashController, :show
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
