dir_name = File.expand_path(File.dirname(__FILE__))
Dir["#{dir_name}/../app/controllers/*_controller.rb"].each {|file| require file }
require_relative 'lib/router'

ROUTER = Router.new

ROUTER.draw do
  get Regexp.new("^/$"), StaticPagesController, :root

  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/users/(?<id>\\d+)/edit$"), UsersController, :edit
  patch Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  delete Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :destroy

  get Regexp.new("^/users/(?<user_id>\\d+)/posts$"), UsersController, :index
  get Regexp.new("^/users/(?<user_id>\\d+)/posts/new$"), UsersController, :new
  post Regexp.new("^/users/(?<user_id>\\d+)/posts$"), UsersController, :create
  get Regexp.new("^/posts/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/posts/(?<id>\\d+)/edit$"), UsersController, :edit
  patch Regexp.new("^/posts/(?<id>\\d+)$"), UsersController, :update
  delete Regexp.new("^/posts/(?<id>\\d+)$"), UsersController, :destroy
end
