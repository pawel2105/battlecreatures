require 'spec_helper'

describe "battles/index" do
  include ViewCapybaraRendered

  before(:each) do
    view.stub!(:current_user).and_return(stub_model(User, id: 50))
  end

  it "should have a welcome message" do
    render
    rendered.should have_css(".welcome_message")
  end

  it "should have the battle rules" do
    render
    rendered.should have_css(".battle_rules")
  end

  it "should have a link to a new battle" do
    render
    rendered.should have_link("new_battle", href: new_battle_path)
  end

  it "should have a link to view one's rank" do
    render
    rendered.should have_link("view_rank", href: user_path(50))
  end

end