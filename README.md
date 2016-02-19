#Laris

A lightweight MVC framework inspired by Ruby on Rails.

To see it in action, check out my minesweeper game: [live][minesweeper]	•  [github][minesweeper-github]

##Getting Started
* Clone the repo
* run `bundle install`
* Put any sql files in db/migrations/  
N.B. starting up the server will reset your db! I'll fix this soon
* Create models for your tables in app/models/

```
# app/models/post.rb

require_relative 'lib/activerecord_base'

class Post < ActiverecordBase
  finalize!

  belongs_to :author, class_name: "User", foreign_key: :user_id
end
```

* Construct routes using a regex, controller name, and method name

```
# config/routes.rb

ROUTER.draw do
  get Regexp.new("^/users$"), UsersController, :index
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
  get Regexp.new("^/users/(?<id>\\d+)/edit$"), UsersController, :edit
  patch Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :update
  delete Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :destroy
end
```
* Add controllers in app/controllers/

```
# app/controllers/users_controller.rb

require_relative 'lib/controller_base'
require_relative '../models/user'

class UsersController < ControllerBase
  def index
    @users = User.all

    render :index
  end
end
```

* Create erb views in app/views/<controller>

```
# app/views/users/index.html.erb

<ul>
  <% @users.each do |user| %>
    <li><%= user.name %></li>
  <% end %>
</ul>
```
* Place any assets in app/assets
* Start a server on localhost: `bundle exec rackup config/server.ru`
* You did it!

[minesweeper]: http://minesweepers.herokuapp.com
[minesweeper-github]: http://github.com/composerinteralia/minesweeper/
