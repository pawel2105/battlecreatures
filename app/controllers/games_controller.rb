class GamesController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def index
    @games = @games.page(params[:page])
  end

  def show

  end

  def new

  end

  def edit

  end

  def create

    if @game.save
      redirect_to @game, notice: 'Game was successfully created.'
    else
      render action: "new"
    end
  end

  def update

    if @game.update_attributes(params[:game])
      redirect_to @game, notice: 'Game was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @game.destroy

    redirect_to games_url
  end
end
