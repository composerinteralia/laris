require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/exception_viewer'
require_relative '../lib/asset_server'

class AssetsController < ControllerBase
  def show
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/$"), AssetsController, :show
end

asset_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use AssetServer
  use ExceptionViewer
  run asset_app
end

Rack::Server.start(
  app: app,
  Port: 3000
)
