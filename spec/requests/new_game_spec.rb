require 'spec_helper'

describe 'Starting a new practice game' do

  it "must allow you to start a new practice game and play" do
    add_headers('X-Mxit-USERID-R' => 'm2604100')
    visit '/'
    click_link('new_practice_game')
    page.should have_content("You have 9 attempts left")
    page.should have_content("______") # better
    click_link('a')
    page.should have_content("You have 8 attempts left")
    page.should have_content("______") # better
    click_link('b')
    page.should have_content("You have 8 attempts left")
    page.should have_content("b_____") # better
  end

end