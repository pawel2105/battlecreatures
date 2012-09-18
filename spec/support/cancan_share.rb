shared_examples "a cancan controller" do

  context "requires authorisation" do

    before(:each) do
      @controller.stub(:current_user).and_return(stub_model(User))
    end

    def response_should_reject_access
      response.should redirect_to("/")
      flash[:alert].should == "You are not authorized to access this page."
    end

    describe "GET index" do
      it "redirects if not logged in" do
        if controller.respond_to?(:index)
          get :index, default_params
          response_should_reject_access
        end
      end
    end

    describe "GET new" do
      it "redirects if not logged in" do
        if controller.respond_to?(:new)
          get :new, default_params
          response_should_reject_access
        end
      end
    end

    describe "POST create" do
      it "redirects if not logged in" do
        if controller.respond_to?(:create)
          post :create, default_params
          response_should_reject_access
        end
      end
    end

    describe "GET show" do
      it "redirects if not logged in" do
        if controller.respond_to?(:show)
          get :show, {id: subject.id}.merge(default_params)
          response_should_reject_access
        end
      end
    end

    describe "GET edit" do
      it "redirects if not logged in" do
        if controller.respond_to?(:edit)
          get :edit, {id: subject.id}.merge(default_params)
          response_should_reject_access
        end
      end
    end

    describe "PUT update" do
      it "redirects if not logged in" do
        if controller.respond_to?(:update)
          get :update, {id: subject.id}.merge(default_params)
          response_should_reject_access
        end
      end
    end

    describe "DELETE destroy" do
      it "redirects if not logged in" do
        if controller.respond_to?(:destroy)
          delete :destroy, {id: subject.id}.merge(default_params)
          response_should_reject_access
        end
      end
    end

  end

end