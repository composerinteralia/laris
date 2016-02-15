require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'cgi'
require_relative './session'
require_relative './flash'
require_relative './csrf_protection'

def h(text)
  CGI::escapeHTML(text)
end

class ControllerBase
  include CSRF

  class DoubleRenderError < StandardError
    def message
      "Render and/or redirect_to were called multiple times in a single action."
    end
  end

  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(req.params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise DoubleRenderError if already_built_response?

    res['Location'] = url
    res.status = 302
    store_cookies(res)

    @already_built_response = true
  end

  def render_content(content, content_type)
    raise DoubleRenderError if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)
    store_cookies(res)

    @already_built_response = true
  end

  def render(template_name)
    dir_path = File.dirname(__FILE__)

    controller = controller_name.remove("_controller")
    path = "#{dir_path}/../../views/#{controller}/#{template_name}.html.erb"

    template = File.read(path)
    content = ERB.new(template).result(binding)

    render_content(content, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name, method)
    if method != :get
      verify_authenticity
    end

    self.send(name)
    render(name) unless already_built_response?
  end

  private
    def store_cookies(req)
      set_session_auth_token
      session.store_session(res)
      flash.store_flash(res)
    end

    def controller_name
      self.class.name.underscore
    end
end
