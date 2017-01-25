require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'cgi'
require 'erb'
require 'json'
require 'pg'
require 'rack'
require 'uri'

require 'laris/asset_server'
require 'laris/autoloader'
require 'laris/controller'
require 'laris/exception_viewer'
require 'laris/larisrecord'
require 'laris/router'

module Laris
  VERSION = '0.0.0'

  def self.app
    DBConnection.open

    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      Laris::Router.run(req, res)
      res.finish
    end

    Rack::Builder.new do
      use ExceptionViewer
      use AssetServer
      run app
    end
  end

  def self.root=(root)
    const_set(:ROOT, root)
  end
end
