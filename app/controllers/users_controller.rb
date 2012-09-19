class UsersController < ApplicationController
  before_filter :login_required

  def show
    @user = User.find_by_id(params[:id]) || current_user
  end
end
