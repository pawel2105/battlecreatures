require 'spec_helper'

describe 'Starting a new practice game' do

  it "must allow you to start a new practice game and win" do
    add_headers('X_MXIT_USERID_R' => 'm2604100')
    create(:word,value: "better")
    visit '/'
    click_link('new_game')
    click_button 'start_game'
    page.should have_content("_ _ _ _ _ _")
    click_link('a')
    page.should have_content("_ _ _ _ _ _")
    click_link('b')
    page.should have_content("b _ _ _ _ _")
    click_link('e')
    page.should have_content("b e _ _ e _") # better
    click_link('t')
    page.should have_content("b e t t e _")
    click_link('r')
    page.should have_content("You win")
    page.should have_content("b e t t e r")
    page.should have_link('new_game')
    page.should have_link('games_index')
  end

  it "must allow you to start a new practice game and lose" do
    add_headers('X_MXIT_USERID_R' => 'm2604100')
    create(:word,value: "tester")
    visit '/'
    click_link('new_game')
    click_button 'start_game'
    %W(a b c d f g h i k).each do |letter|
      click_link(letter)
      page.should have_content("_ _ _ _ _ _")
    end
    click_link 'j'
    page.should have_content("You lose")
    page.should have_content("t e s t e r")
    page.should have_link('new_game')
    page.should have_link('games_index')
  end

end