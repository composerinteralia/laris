class AssetServer
  attr_reader :app, :res

  def initialize(app)
    @app = app
    @res = Rack::Response.new
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path =~ (/^\/public/)
      respond_with_asset(req)
    else
      app.call(env)
    end
  end

  private
  def respond_with_asset(req)
    res["Content-Type"] = "mime"
    dir_path = File.dirname(__FILE__)
    res.write(File.read("#{dir_path}/..#{req.path}"))
    res.finish
  end
end
