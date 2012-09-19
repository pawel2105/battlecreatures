require 'spec_helper'

describe "games/index" do
  include ViewCapybaraRendered

  before(:each) do
    @games =
    assign(:games, [
      stub_model(Game, id: 100, done?: true, hangman_text: "hello", score: 100),
      stub_model(Game, id: 101, done?: false, hangman_text: "goodbye", score: 500)
    ])
    view.stub!(:paginate)
  end

  it "renders a list of games" do
    render
    within("#game_100") do
      rendered.should have_content("hello")
      rendered.should have_content("100")
    end
    within("#game_101") do
      rendered.should have_content("goodbye")
      rendered.should have_content("500")
    end
  end

  it "renders a actions of games" do
    render
    within("#game_100") do
      rendered.should have_link("show_game_100", href: game_path(100))
    end
    within("#game_101") do
      rendered.should have_link("show_game_101", href: game_path(101))
    end
  end

  it "should have a new_game link" do
    render
    rendered.should have_link("new_game", href: new_game_path)
  end

  it "should rendered the pagination" do
    view.should_receive(:paginate).with(@games).and_return("<span>Pagination</span>")
    render
    rendered.should have_content("Pagination")
  end

end