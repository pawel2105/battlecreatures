class GamesController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def index
    @games = @games.active_first.page(params[:page])
  end

  def show

  end

  def play_letter
    week_rating, monthly_rating = @game.user.weekly_rating, @game.user.monthly_rating
    @game.add_choice(params[:letter])
    @game.save
    if week_rating < @game.user.weekly_rating
      @notice = "Your weekly rating has increase to #{@game.user.weekly_rating}, your weekly rank is #{@game.user.weekly_rank}"
    elsif monthly_rating < @game.user.monthly_rating
      @notice = "Your monthly rating has increase to #{@game.user.monthly_rating}, your monthly rank is #{@game.user.monthly_rank}"
    end
    redirect_to @game, notice: @notice
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
