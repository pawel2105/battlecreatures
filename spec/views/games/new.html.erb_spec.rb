require 'spec_helper'

describe "games/new" do
  before(:each) do
    assign(:game, stub_model(Game).as_new_record)
  end

  it "renders new game form" do
    render
    rendered.should have_button('start_game')
  end
end
