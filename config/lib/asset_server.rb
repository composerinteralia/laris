class AssetServer
  attr_reader :app, :res

  def initialize(app)
    @app = app
    @res = Rack::Response.new
  end

  def call(env)
    req = Rack::Request.new(env)
    if req.path =~ (/^\/assets/)
      respond_with_asset(req)
    else
      app.call(env)
    end
  end

  private
  def respond_with_asset(req)
    dir_path = File.dirname(__FILE__)
    path = "#{dir_path}/../../app#{req.path}"

    ext = File.extname(path)
    res["Content-Type"] = Rack::Mime::MIME_TYPES[ext]

    res.write(File.read(path))
    res.finish
  end
end
