class BattlesController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource

  def new
  end

  def rules
  end

  def learn
  end

  def fight
    @battle = Battle.new(choices: params[:player])
    @battle.user = current_user
    @battle.save
  end

end
