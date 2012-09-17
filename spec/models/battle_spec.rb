require 'spec_helper'

describe Battle do

  it "must have a user" do
    Battle.new.should respond_to(:user)
  end

  it "opponent must be one of the 5 creatures" do
    @user = create(:user)
    @battle = create(:battle, user: @user)
    ["vampire","zombie","pirate","ninja","robot"].should include @battle.select_random_opponent
  end

  it "opponent must be random" do
    @user = create(:user)
    @battle = create(:battle, user: @user)
    a = @battle.select_random_opponent
    b = @battle.select_random_opponent
    c = @battle.select_random_opponent
    d = @battle.select_random_opponent
    e = @battle.select_random_opponent
    f = @battle.select_random_opponent
    g = @battle.select_random_opponent
    h = @battle.select_random_opponent
    i = @battle.select_random_opponent
    j = @battle.select_random_opponent
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

  context "deleting old battles" do

    it "must remove a user's battles if they're older than 2 days" do
      long_ago = 1.year.ago
      create(:battle, created_at: long_ago)

      Timecop.freeze(long_ago) do
        Battle.count.should == 0
      end
    end

    it "doesn't remove a user's recent battles" do
      not_long_ago = 23.hours.ago
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

    # scores faked below because can't create factory with specified opponent
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