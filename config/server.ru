require 'rack'
require_relative 'routes'
require_relative 'lib/asset_server'
require_relative 'lib/exception_viewer'
require_relative '../db/lib/db_connection'

DBConnection.open

asset_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ExceptionViewer
  use AssetServer
  run asset_app
end

run app
