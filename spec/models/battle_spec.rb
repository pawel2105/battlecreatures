require 'spec_helper'

describe Battle do

  it "must have a user" do
    Battle.new.should respond_to(:user)
  end

  it "opponent must be one of the 5 creatures" do
    ["vampire","zombie","pirate","ninja","robot"].should include Battle.new.select_random_opponent
  end

  it "opponent must be random" do
    a = Battle.new.select_random_opponent
    b = Battle.new.select_random_opponent
    c = Battle.new.select_random_opponent
    d = Battle.new.select_random_opponent
    e = Battle.new.select_random_opponent
    f = Battle.new.select_random_opponent
    g = Battle.new.select_random_opponent
    h = Battle.new.select_random_opponent
    i = Battle.new.select_random_opponent
    j = Battle.new.select_random_opponent
    battles = []
    battles << a
    battles << b 
    battles << c 
    battles << d 
    battles << e 
    battles << f 
    battles << g 
    battles << h 
    battles << i 
    battles << j
    battles.uniq.size.should > 1
  end

  # context "add_choice" do

  #   before :each do
  #     @battle = Battle.new
  #     @battle.stub!(:attempts_left).and_return(1)
  #   end

  #   it "must allow to add choices if there are still attempts left" do
  #     @battle.should_receive(:attempts_left).and_return(1)
  #     @battle.add_choice("a")
  #     @battle.choices.should include("a")
  #   end

  #   it "wont allow to add choices if there not attempts left" do
  #     @battle.should_receive(:attempts_left).and_return(0)
  #     @battle.add_choice("a")
  #     @battle.choices.should_not include("a")
  #   end

  #   it "wont allow to add choices if more than a letter" do
  #     @battle.add_choice("ab")
  #     @battle.choices.should_not include("a")
  #     @battle.choices.should_not include("b")
  #   end

  #   it "must downcase letters" do
  #     @battle.add_choice("C")
  #     @battle.choices.should include("c")
  #   end

  #   it "must be able to add all letters" do
  #     ("a".."z").each do |letter|
  #       @battle.add_choice(letter)
  #       @battle.choices.should include(letter)
  #     end
  #     ("1".."9").each do |number|
  #       @battle.add_choice(number)
  #       @battle.choices.should_not include(number)
  #     end
  #   end

  # end

  # context "attempts_left" do

  #   it "must return the correct amount for no attempts" do
  #     battle = Battle.new(word: "testing")
  #     battle.attempts_left.should == Battle::ATTEMPTS
  #   end

  #   it "must return the correct amount for attempts" do
  #     battle = Battle.new(word: "testing", choices: "a")
  #     battle.attempts_left.should == Battle::ATTEMPTS - 1
  #     battle = Battle.new(word: "testing", choices: "ab")
  #     battle.attempts_left.should == Battle::ATTEMPTS - 2
  #     battle = Battle.new(word: "testing", choices: "testin")
  #     battle.attempts_left.should == Battle::ATTEMPTS
  #     battle = Battle.new(word: "testing", choices: "atestinb")
  #     battle.attempts_left.should == Battle::ATTEMPTS - 2
  #   end

  # end

  # context "correct_choices" do

  #   it "must return the correct amount for attempts" do
  #     battle = Battle.new(word: "testing", choices: "a")
  #     battle.should have(0).correct_choices
  #     battle = Battle.new(word: "testing", choices: "at")
  #     battle.should have(1).correct_choices
  #     battle = Battle.new(word: "testing", choices: "test")
  #     battle.should have(3).correct_choices
  #     battle = Battle.new(word: "testing", choices: "atestinb")
  #     battle.should have(5).correct_choices
  #   end

  # end

  # context "hangman_text" do

  #   it "must return the correct hangman text" do
  #     battle = Battle.new(word: "hangman", choices: "angmh")
  #     battle.hangman_text.should == "hangman"
  #     battle = Battle.new(word: "hangman", choices: "b")
  #     battle.hangman_text.should == "_______"
  #     battle = Battle.new(word: "hangman", choices: "a")
  #     battle.hangman_text.should == "_a___a_"
  #     battle = Battle.new(word: "hangman", choices: "ahca")
  #     battle.hangman_text.should == "ha___a_"
  #   end

  #   it "must return the full word if battle done" do
  #     battle = Battle.new(word: "hangman", choices: "a")
  #     battle.should_receive(:done?).and_return(true)
  #     battle.hangman_text.should == "hangman"
  #   end

  # end

  # context "done?" do

  #   it "must be done if no more attempts left" do
  #     battle = Battle.new
  #     battle.should_receive(:attempts_left).and_return(0)
  #     battle.should be_done
  #   end

  #   it "must be done if all letters chosen" do
  #     battle = Battle.new(word: "hangman", choices: "angmh")
  #     battle.should be_done
  #   end

  # end

  context "deleting old battles" do

    it "must remove a user's battles if they're older than 2 days" do
      long_ago = 1.year.ago
      create(:battle, created_at: long_ago)

      Timecop.freeze(long_ago) do
        Battle.count.should == 0
      end
    end

    it "doesn't remove a user's recent battles" do
      not_long_ago = 25.hours.ago
      create(:battle, created_at: not_long_ago)

      Timecop.freeze(not_long_ago) do
        Battle.count.should == 1
      end
    end

  end

  context "updating a user's score" do

    before :each do
      @user = create(:user, daily_score: 0)
    end

    it "increment score if battle is won" do
      @battle = create(:battle, user: @user, choices: "pirate", created_at: 1.minute.ago)
      @battle.update_attributes(opponent: "vampire")
      @battle.save
      @user.daily_score.should == 1
    end

    # scores stubbed below because can't create factory with specified opponent
    # because method will always give random opponent

    it "decrement score if battle is lost" do
      @battle = create(:battle, user: @user, choices: "vampire", score: -1, created_at: 1.minute.ago)
      @battle.update_attributes(opponent: "pirate")
      @battle.save
      @user.daily_score.should == -1
    end

    it "leave score the same if battle is a draw" do
      @battle = create(:battle, user: @user, choices: "zombie", score: 0, created_at: 1.minute.ago)
      @battle.update_attributes(opponent: "zombie")
      @battle.save
      @user.daily_score.should == 0
    end

  end

end