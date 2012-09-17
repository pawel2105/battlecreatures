require 'spec_helper'

describe "games/edit" do
  before(:each) do
    @game = assign(:game, stub_model(Game,
      :word => "MyString",
      :choices => "MyText",
      :user => nil
    ))
  end

  it "renders the edit game form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => games_path(@game), :method => "post" do
      assert_select "input#game_word", :name => "game[word]"
      assert_select "textarea#game_choices", :name => "game[choices]"
      assert_select "input#game_user", :name => "game[user]"
    end
  end
end
