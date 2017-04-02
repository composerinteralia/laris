# Laris

A lightweight MVC framework inspired by Ruby on Rails.

To see it in action, check out my minesweeper game: [live][minesweeper]	•  [github][minesweeper-github]

[minesweeper]: http://minesweepers.herokuapp.com
[minesweeper-github]: http://github.com/composerinteralia/minesweeper/

## Getting Started
* `gem install laris`
* Put sql files in `db/migrations/` numbered in the order you want them to be
executed (NB I need to add a rake task for migrating. At the moment you will
need to run `DBConnection.migrate` yourself)
* Create models in app/models/

```rb
# app/models/post.rb

class Post < LarisrecordBase
  belongs_to :author, class_name: "User", foreign_key: :user_id
end
```

* Construct routes using a regex, controller name, and method name

```rb
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

```rb
# app/controllers/users_controller.rb

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
* You will need a database URL to run locally (yeah, I have work to do). If you
are feeling adventurous, you can use your Heroku database URL, but probably you shouldn't...

```sh
export DATABASE_URL=$(heroku config -s | grep DATABASE_URL | sed -e "s/^DATABASE_URL='//" -e "s/'//")
```

* Add these to the root of your project:

```rb
# laris.ru

require 'laris'
Laris.root = File.expand_path(File.dirname(__FILE__))

require_relative 'config/routes'

run Laris.app
```

```
# Procfile

web: bundle exec rackup laris.ru -p $PORT
```

* Start up your app with `bundle exec rackup laris.ru` or push to Heroku
* You did it!

## TODO
* Database config file
* Rake task for migrations
* Migrations in Ruby, not raw SQL
* `laris new`
