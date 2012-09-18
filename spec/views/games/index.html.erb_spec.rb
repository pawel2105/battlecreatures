require 'spec_helper'

describe "games/index" do
  include ViewCapybaraRendered

  before(:each) do
    @games =
    assign(:games, [
      stub_model(Game, id: 100 ,
        level: "Level"
      ),
      stub_model(Game, id: 101 ,
        level: "Level"
      )
    ])
    view.stub!(:paginate)
  end

  it "renders a list of games" do
    render
    within("#game_100") do
      rendered.should have_content("Level")
    end
    within("#game_101") do
      rendered.should have_content("Level")
    end
  end

  it "renders a actions of games" do
    render
    within("#game_100") do
      rendered.should have_link("show_game_100")
      rendered.should have_link("delete_game_100")
      rendered.should have_link("edit_game_100")
    end
    within("#game_101") do
      rendered.should have_link("show_game_101")
      rendered.should have_link("delete_game_101")
      rendered.should have_link("edit_game_101")
    end
  end

  it "should rendered the pagination" do
    view.should_receive(:paginate).with(@games).and_return("<span>Pagination</span>")
    render
    rendered.should have_content("Pagination")
  end

end