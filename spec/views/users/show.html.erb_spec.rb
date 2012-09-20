require 'spec_helper'

describe "users/show.html.erb" do
  include ViewCapybaraRendered

  before(:each) do
    @user = assign(:user, stub_model(User, game_count: 100,
                                           weekly_rank: 1, weekly_rating: 20,
                                           monthly_rank: 2, monthly_rating: 80,
                                           yearly_rank: 3, yearly_rating: 960))
  end

  it "renders a list of games" do
    render
    rendered.should have_content("Games Played: 100")
    rendered.should have_content("Week Rank: 1st")
    rendered.should have_content("Month Rank: 2nd")
    rendered.should have_content("Year Rank: 3rd")
    rendered.should have_content("Week Rating: 20")
    rendered.should have_content("Month Rating: 80")
    rendered.should have_content("Year Rating: 960")
  end

  it "should have a home page link" do
    render
    rendered.should have_link("root_page", href: '/')
  end

  it "should have a link to top weekly users" do
    render
    rendered.should have_link("view_top_week_users", href: users_path(order: 'top_week'))
  end

  it "should have a link to top monthly users" do
    render
    rendered.should have_link("view_top_month_users", href: users_path(order: 'top_month'))
  end

end
