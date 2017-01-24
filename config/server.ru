require_relative 'lib/dependencies'
require_relative 'lib/autoloader'
require_relative 'routes'
require_relative '../db/lib/db_connection'

DBConnection.open

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  ROUTER.run(req, res)
  res.finish
end

laris = Rack::Builder.new do
  use ExceptionViewer
  use AssetServer
  run app
end

run laris
