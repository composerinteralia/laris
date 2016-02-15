require 'rack'
require_relative 'lib/controller_base'

class ExceptionsController < ControllerBase
  def show
    render :this_does_not_exist
  end
end
