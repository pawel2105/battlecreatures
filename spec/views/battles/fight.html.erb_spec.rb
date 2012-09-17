require 'spec_helper'

describe "battles/fight" do
  before(:each) do
    @battle = assign(:battle, stub_model(Battle))
    view.stub!(:current_user).and_return(stub_model(User, id: 50))
  end

  it "should link to a new battle" do
    render
    rendered.should have_link("new_battle", href: new_battle_path)
  end

  it "should link to the lobby" do
    render
    rendered.should have_link("lobby", href: root_path)
  end

  it "should have a view rank link" do
    @battle.stub(:set_score).and_return(true)
    render
    rendered.should have_link("view_rank", href: user_path(50))
  end

  it "must have correct text if the battle is lost" do
    @battle.stub(:outcome).and_return("lose")
    render
    rendered.should have_content("has beaten you!")
  end

  it "must have correct text if the battle is won" do
    @battle.stub(:outcome).and_return("win")
    render
    rendered.should have_content("You have defeated")
  end

  it "must have correct text if the battle is a draw" do
    @battle.stub(:outcome).and_return("draw")
    render
    rendered.should have_content("You have drawn with")
  end

end
