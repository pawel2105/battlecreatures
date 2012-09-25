require "spec_helper"

describe UsersController do

  describe "routing" do

    it "routes to #define" do
      get("/define/dog").should route_to("words#define", word: "dog")
    end

  end
end
