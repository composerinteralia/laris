require 'rack'
require_relative "routes"
require_relative 'lib/asset_server'
require_relative 'lib/exception_viewer'

asset_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  # local variable not defined here!
  ROUTER.run(req, res)
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
