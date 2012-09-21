require 'spec_helper'

describe ApplicationController do

  describe "handling CanCan AccessDenied exceptions" do

    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    it "redirects to the /401.html page" do
      get :index
      response.should redirect_to("/")
      flash[:alert].should_not be_blank
    end
  end

  describe "it attempts to load the mxit user" do

    controller do
      def index
        render :text => "hello"
      end
    end

    context "has mxit headers" do

      before :each do
        request.env['HTTP_X_MXIT_USERID_R'] = 'm2604100'
        request.env['HTTP_X_MXIT_NICK'] = 'grant'
      end

      it "loads the mxit user into current_user" do
        User.should_receive(:find_or_create_from_auth_hash).with(uid: 'm2604100', provider: 'mxit', info: {name: 'grant'})
        get :index
      end

      it "must assign the mxit user" do
        User.stub!(:find_or_create_from_auth_hash).and_return('mxit_user')
        get :index
        assigns(:current_user).should == 'mxit_user'
      end

    end

    it "wont load mxit user if no userid" do
      User.should_not_receive(:find_or_create_from_auth_hash)
      get :index
      assigns(:current_user).should be_nil
    end

  end

  describe "it attempts to load the facebook user" do

    controller do
      def index
        render :text => "hello"
      end
    end

    it "wont load mxit user if no userid" do
      text = "vlXgu64BQGFSQrY0ZcJBZASMvYvTHu9GQ0YM9rjPSso.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsIjAiOiJwYXlsb2FkIn0"
      User.should_not_receive(:find_or_create_from_auth_hash)
      get :index, signed_request: text
      assigns(:data).should == {"algorithm"=>"HMAC-SHA256", "0"=>"payload"}
    end

  end

end