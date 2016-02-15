require 'rack'
require_relative 'lib/controller_base'

class FlashController < ControllerBase
  def flash_me
    flash['persist'] = "This message should persist exactly once"
    flash.now['die'] = "This message should not persist"
    render :show
  end

  def show
    render :show
  end
end
