dir_name = File.expand_path(File.dirname(__FILE__))
Dir["#{dir_name}/../app/controllers/*_controller.rb"].each {|file| require file }
require_relative 'lib/router'

ROUTER = Router.new

ROUTER.draw do

end
