require 'spec_helper'

describe UsersController do

  context "functionality" do

    before :each do
      @current_user = create(:user)
      controller.stub(:current_user).and_return(@current_user)
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show'
        response.should be_success
      end

      it "assigns the requested user as @user" do
        get 'show'
        assigns(:user).should eq(@current_user)
      end

    end

  end

end
