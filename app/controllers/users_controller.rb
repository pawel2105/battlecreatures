class UsersController < ApplicationController
  before_filter :login_required, :except => :facebook_oauth

  def index
    case params[:order]
      @users = User.today(10)
  end

  def show
    @user = User.find_by_id(params[:id]) || current_user
  end
end
