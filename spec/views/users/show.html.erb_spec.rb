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
    rendered.should have_content("Week Score: 20")
    rendered.should have_content("Month Score: 80")
    rendered.should have_content("Year Score: 960")
  end

  it "should have a home page link" do
    render
    rendered.should have_link("root_page", href: '/')
  end

end
