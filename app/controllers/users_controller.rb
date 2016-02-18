require_relative 'lib/controller_base'
require_relative '../models/user'

class UsersController < ControllerBase
  def create

    render :show
  end

  def destroy

    # redirect
  end

  def edit

    render :edit
  end

  def index
    @users = User.all.to_a

    render :index
  end

  def new

    render :new
  end

  def show
    @user = User.find(params["id"].to_i)
  end

  def update

    render :show
  end
end
