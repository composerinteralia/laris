require_relative 'controller/controller_base'
require_relative 'controller/csrf'
require_relative 'controller/flash'
require_relative 'controller/session'

class ControllerBase
  include CSRF
end
