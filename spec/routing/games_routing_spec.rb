require "spec_helper"

describe GamesController do
  describe "routing" do

    it "routes to #index" do
      get("/games").should route_to("games#index")
    end

    it "routes to #new" do
      get("/games/new").should route_to("games#new")
    end

    it "routes to #show" do
      get("/games/1").should route_to("games#show", :id => "1")
    end

    it "routes to #create" do
      post("/games").should route_to("games#create")
    end

    it "routes to #show" do
      get("/games/1/letter/a").should route_to("games#play_letter", id: "1", letter: "a")
    end

  end
end
