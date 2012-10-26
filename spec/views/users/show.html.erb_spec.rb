require 'spec_helper'

describe "users/show.html.erb" do
  include ViewCapybaraRendered

  before(:each) do
    @user = assign(:user, stub_model(User, battle_count: 100,
                                           daily_rank: 3, daily_score: 960,
                                           weekly_rank: 1, weekly_score: 20))
  end

  it "renders a list of battles" do
    render
    rendered.should have_content("Your rank for the day: 1st")
    rendered.should have_content("Your score for today: 960")
    rendered.should have_content("Your rank for the last 2 days: 3rd")
    rendered.should have_content("Your score for the last 2 days: 20")
  end

  it "should have a home page link" do
    render
    rendered.should have_link("root_page", href: '/')
  end

  it "should have a link to top daily users" do
    render
    rendered.should have_link("view_top_day_users", href: users_path(order: 'top_day'))
  end

  it "should have a link to top weekly users" do
    render
    rendered.should have_link("view_top_week_users", href: users_path(order: 'top_week'))
  end

end
