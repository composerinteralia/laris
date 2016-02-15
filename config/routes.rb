dir_name = File.expand_path(File.dirname(__FILE__))
Dir["#{dir_name}/../app/controllers/*_controller.rb"].each {|file| require file }
require_relative 'lib/router'

ROUTER = Router.new

ROUTER.draw do
  get Regexp.new("^/assets$"), AssetsController, :show
  post Regexp.new("^/assets$"), AssetsController, :create

  get Regexp.new("^/exceptions$"), ExceptionsController, :show

  get Regexp.new("^/flash$"), FlashController, :flash_me
  get Regexp.new("^/$"), FlashController, :show
end
