require "spec_helper"

describe UsersController do

  describe "routing" do

    it "routes to #show" do
      get("/users/1").should route_to("users#show", :id => "1")
    end

    it "routes to #index" do
      get("/users").should route_to("users#index")
    end

  end
end
