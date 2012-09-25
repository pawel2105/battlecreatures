require 'spec_helper'

describe "words/define.html.erb" do

  before(:each) do
    @definition = assign(:definition, "The Text definition")
    view.stub!(:current_user).and_return(stub_model(User, id: 50))
  end

  it "must show the definition" do
    render
    rendered.should have_content(@definition)
  end

  it "must have new game link" do
    render
    rendered.should have_link('new_game', href: new_game_path)
  end

  it "should have a view rank link" do
    render
    rendered.should have_link("view_rank", href: user_path(50))
  end

  it "should have a home page link" do
    render
    rendered.should have_link("root_page", href: '/')
  end

end
