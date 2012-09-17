require 'spec_helper'

describe 'Starting a new battle' do

  it "must let you battle" do
    add_headers('X_MXIT_USERID_R' => 'm2604100')
    visit '/'
    click_link('new_battle')
    click_link 'vampire'
    page.should have_css("#outcome")
    page.should have_link("view_rank")
    page.should have_link('new_battle')
    page.should have_link('lobby')
  end

  # it "a draw must not change the score" do
  #   add_headers('X_MXIT_USERID_R' => 'm2604100')
  #   visit '/'
  #   click_link('new_battle')
  #   click_link 'vampire'
  #   #stuff
  #   page.should have_content("You have drawn with the vampire")
  # end

  # it "a win must increase the score" do
  #   add_headers('X_MXIT_USERID_R' => 'm2604100')
  #   visit '/'
  #   click_link('new_battle')
  #   click_link 'vampire'
  #   #stuff
  #   page.should have_content("You have defeated the robot")
  # end

end