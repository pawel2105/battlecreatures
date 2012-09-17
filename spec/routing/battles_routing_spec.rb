require "spec_helper"

describe BattlesController do
  describe "routing" do

    it "routes to #new" do
      get("/battles/new").should route_to("battles#new")
    end

    it "routes to #fight" do
      get("/battles/vampire").should route_to("battles#fight", :player => "vampire")
    end

  end
end
