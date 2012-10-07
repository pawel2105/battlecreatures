require 'spec_helper'

describe 'users' do

  before :each do
    @current_user = create(:user, uid: 'm2604100', name: "Pete", provider: 'mxit', daily_score: 21, weekly_score: 88)
    @user = create(:user, uid: 'm2604102', name: "Sarah", provider: 'mxit', daily_score: 3, weekly_score: 84)
    add_headers('X_MXIT_USERID_R' => 'm2604100')
  end

  it "must show users rating" do
    visit '/'
    click_link('view_rank')
    page.should have_content("Your rank for the day: 1st")
    page.should have_content("Your rank for the week: 1st")
    page.should have_content("Your score for today: 21")
    page.should have_content("Your score for the week: 88")
    page.should have_link("view_top_day_users")
    page.should have_link("view_top_week_users")
  end

  it "must show top users for the day" do
    visit '/'
    click_link('view_rank')
    click_link('view_top_day_users')
    page.should have_content("Pete - 21")
    page.should have_content("Sarah - 3")
    page.should have_link("view_rank")
    page.should have_link("root_page")
  end

  it "must show top users for the week" do
    visit '/'
    click_link('view_rank')
    click_link('view_top_week_users')
    page.should have_content("Pete - 88")
    page.should have_content("Sarah - 84")
    page.should have_link("view_rank")
    page.should have_link("root_page")
  end

end