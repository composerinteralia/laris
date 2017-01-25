class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    pattern =~ req.path &&
      http_method == req.request_method.downcase.to_sym
  end

  def run(req, res)
    match_data = pattern.match(req.path)
    route_params = Hash[match_data.names.zip(match_data.captures)]

    controller = controller_class.new(req, res, route_params)
    controller.invoke_action(action_name, http_method)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, http_method, controller_class, action_name)
    @routes << Route.new(pattern, http_method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :patch, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  def run(req, res)
    route = match(req)

    if route.nil?
      res.status = 404

      res.write("Oops! The requested URL #{req.path} was not not found!")
    else
      route.run(req, res)
    end
  end
end

Laris::Router = Router.new
