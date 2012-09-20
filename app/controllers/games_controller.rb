class GamesController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def index
    @games = @games.active_first.page(params[:page])
  end

  def show

  end

  def play_letter
    @game.add_choice(params[:letter])
    @game.save
    redirect_to action: 'show'
  end

  def new

  end

  def create
    @game.user = current_user
    @game.select_random_word
    if @game.save
      redirect_to @game, notice: 'Game was successfully created.'
    else
      redirect_to({action: 'index'}, alert: 'Failed to create new game.')
    end
  end

end
