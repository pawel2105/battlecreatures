require 'spec_helper'

describe "games/show" do
  before(:each) do
    @game = assign(:game, stub_model(Game,attempts_left: 5,
                                          hangman_text: "__t__",
                                          done?: false,
                                          is_won?: false,
                                          is_lost?: false))
    view.stub!(:current_user).and_return(stub_model(User, id: 50))
  end

  it "must show the attempts left" do
    render
    rendered.should have_content("5")
    rendered.should have_content("__t__")
  end

  it "must have a games index link" do
    render
    rendered.should have_link("games_index", href: games_path)
  end

  it "must have a letter link for each letter" do
    render
    ("a".."z").each do |letter|
      rendered.should have_link(letter, href: play_letter_game_path(@game,letter))
    end
  end

  it "wont letter links that are already chosen" do
    @game.stub!(:choices).and_return("cz")
    render
    rendered.should_not have_link('c', href: play_letter_game_path(@game,'c'))
    rendered.should_not have_link('z', href: play_letter_game_path(@game,'c'))
  end

  it "wont show the letters if game is done" do
    @game.stub(:done?).and_return(true)
    render
    ("a".."z").each do |letter|
      rendered.should_not have_link(letter, href: play_letter_game_path(@game,letter))
    end
  end

  it "must have new game link if done" do
    @game.stub(:done?).and_return(true)
    render
    rendered.should have_link('new_game', href: new_game_path)
  end

  it "should have a view rank link if done" do
    @game.stub(:done?).and_return(true)
    render
    rendered.should have_link("view_rank", href: user_path(50))
  end

  it "wont have new game link if not done" do
    render
    rendered.should_not have_link('new_game', href: new_game_path)
  end

  it "must have correct text if you win" do
    @game.stub(:is_won?).and_return(true)
    render
    rendered.should have_content("You win")
  end

  it "must have correct text if you lose" do
    @game.stub(:is_lost?).and_return(true)
    render
    rendered.should have_content("You lose")
  end

end
