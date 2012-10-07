class UsersController < ApplicationController
  before_filter :login_required, :except => :facebook_oauth

  def index
    case params[:order]
      when 'top_week'
        @users = User.this_week(10)
      else
        @users = User.today(10)
    end
  end

  def show
    @user = User.find_by_id(params[:id]) || current_user
  end
end
