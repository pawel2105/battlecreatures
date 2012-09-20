require 'spec_helper'

describe "users/index" do
  include ViewCapybaraRendered

  before(:each) do
    @users =
    assign(:users, [
      stub_model(User, id: 100, name: "hello"),
      stub_model(User, id: 101, name: "goodbye")
    ])
    view.stub!(:paginate)
    view.stub!(:current_user).and_return(stub_model(User, id: 50))
  end

  it "renders a list of users" do
    render
    within("#user_100") do
      rendered.should have_content("hello")
    end
    within("#user_101") do
      rendered.should have_content("goodbye")
    end
  end

  it "should have a home page link" do
    render
    rendered.should have_link("root_page", href: '/')
  end

  it "should have a view rank link" do
    render
    rendered.should have_link("view_rank", href: user_path(50))
  end


end