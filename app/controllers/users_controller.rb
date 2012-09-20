class UsersController < ApplicationController
  before_filter :login_required

  def index
    case params[:order]
      when 'top_week'
        @users = User.top_this_week(10)
      else
        @users = User.top_this_month(10)
    end
  end

  def show
    @user = User.find_by_id(params[:id]) || current_user
  end
end
