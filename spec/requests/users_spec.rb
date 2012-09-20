require 'spec_helper'

describe 'users' do

  it "must show users rating" do
    user = create(:user, uid: 'm2604100', provider: 'mxit')
    score = create(:won_game, user: user).score
    add_headers('X_MXIT_USERID_R' => 'm2604100')
    visit '/'
    click_link('view_rank')
    page.should have_content("Games Played: 1")
    page.should have_content("Week Rank: 1st")
    page.should have_content("Month Rank: 1st")
    page.should have_content("Year Rank: 1st")
    page.should have_content("Week Rating: #{score}")
    page.should have_content("Month Rating: #{score}")
    page.should have_content("Year Rating: #{score}")
    click_link('root_page')
    page.current_path.should == '/'
  end

end