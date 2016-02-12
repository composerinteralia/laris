require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/exception_viewer'

class ExceptionsController < ControllerBase
  def show
    render :this_does_not_exist
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/$"), ExceptionsController, :show
end

exception_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ExceptionViewer
  run exception_app
end

Rack::Server.start(
  app: app,
  Port: 3000
)
