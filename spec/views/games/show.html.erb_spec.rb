require 'spec_helper'

describe "games/show" do
  before(:each) do
    @game = assign(:game, stub_model(Game,attempts_left: 5))
  end

  it "must show the attempts left" do
    render
    rendered.should have_content("5")
  end

  it "must have a games index link" do
    render
    rendered.should have_link("games_index", href: games_path)
  end

end
