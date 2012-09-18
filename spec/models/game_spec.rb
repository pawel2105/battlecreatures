require 'spec_helper'

describe Game do

  it "must have a word" do
    Game.new.should have(1).errors_on(:word)
    Game.new(word: 'xx').should have(0).errors_on(:word)
  end

  it "must have a user" do
    Game.new.should have(1).errors_on(:user_id)
    Game.new(user_id: 123).should have(0).errors_on(:user_id)
  end

  it "must generate a word" do
    Word.should_receive(:random_value).and_return('wood')
    game = Game.new
    game.select_random_word
    game.word.should == "wood"
  end

  context "add_choice" do

    before :each do
      @game = Game.new
      @game.stub!(:attempts_left).and_return(1)
    end

    it "must allow to add choices if there are still attempts left" do
      @game.should_receive(:attempts_left).and_return(1)
      @game.add_choice("a")
      @game.choices.should include("a")
    end

    it "wont allow to add choices if there not attempts left" do
      @game.should_receive(:attempts_left).and_return(0)
      @game.add_choice("a")
      @game.choices.should_not include("a")
    end

    it "wont allow to add choices if more than a letter" do
      @game.add_choice("ab")
      @game.choices.should_not include("a")
      @game.choices.should_not include("b")
    end

    it "must downcase letters" do
      @game.add_choice("C")
      @game.choices.should include("c")
    end

    it "must be able to add all letters" do
      ("a".."z").each do |letter|
        @game.add_choice(letter)
        @game.choices.should include(letter)
      end
      ("1".."9").each do |number|
        @game.add_choice(number)
        @game.choices.should_not include(number)
      end
    end

  end

  context "attempts_left" do

    it "must return the correct amount for no attempts" do
      game = Game.new(word: "testing")
      game.attempts_left.should == Game::ATTEMPTS
    end

    it "must return the correct amount for attempts" do
      game = Game.new(word: "testing", choices: "a")
      game.attempts_left.should == Game::ATTEMPTS - 1
      game = Game.new(word: "testing", choices: "ab")
      game.attempts_left.should == Game::ATTEMPTS - 2
      game = Game.new(word: "testing", choices: "testin")
      game.attempts_left.should == Game::ATTEMPTS
      game = Game.new(word: "testing", choices: "atestinb")
      game.attempts_left.should == Game::ATTEMPTS - 2
    end

  end

end
