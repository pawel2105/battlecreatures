require 'spec_helper'

describe User do

  it "must have a provider" do
    User.new.should have(1).errors_on(:provider)
    User.new(provider: 'xx').should have(0).errors_on(:provider)
  end

  it "must have a uid" do
    User.new.should have(1).errors_on(:uid)
    User.new(uid: 'xx').should have(0).errors_on(:uid)
  end

  it "must have a unique uid per provider" do
    create(:user, uid: "xx", provider: "yy")
    User.new(uid: 'xx', provider: "yy").should have(1).errors_on(:uid)
    User.new(uid: 'xx', provider: "zz").should have(0).errors_on(:uid)
  end

  it "must have a daily rating" do
    User.new.should respond_to(:daily_score)
  end

  it "must have a week rating" do
    User.new.should respond_to(:weekly_score)
  end

  it "must be able to have battles" do
    User.new.should respond_to(:battles)
  end

  context "calculate daily score" do

    it "must have 20 battles in the last week" do
      user = create(:user)
      create_list(:battle, 15, created_at: 2.hours.ago, score: 1, user: user)
      create_list(:battle, 2, created_at: 2.hours.ago, score: -1, user: user)
      create_list(:battle, 1, created_at: 25.hours.ago, score: 1, user: user)
      user.calculate_daily_score.should == 13
    end

  end

  context "calculate weekly score" do

    before :each do
      @user = create(:user)
      create_list(:battle, 20, score: 1, user: @user)
    end

    it "must have the right score for the last week" do
      @user.calculate_weekly_score.should == 20
    end

    it "must calculate scores only from battles within the last week" do
      create(:battle, score: 20, created_at: 2.weeks.ago, user: @user)
      @user.calculate_weekly_score.should == 20
    end

  end

  context "updating scores" do

    it "must accurately update the scores for a user" do
      user = create(:user)
      create(:battle, score: 13, created_at: 2.weeks.ago, user: user) 
      create(:battle, score: 9, created_at: 2.days.ago, user: user) 
      create(:battle, score: 7, created_at: 2.minutes.ago, user: user)
      user.update_scores
      user.daily_score.should == 7
      user.weekly_score.should == 16
    end

  end

  context "rankings" do

    it "must be correct for the user" do
      user = create(:user)
      other_user = create(:user)
      user.stub(:calculate_daily_score).and_return(20)
      user.stub(:calculate_weekly_score).and_return(180)
      other_user.stub(:calculate_daily_score).and_return(30)
      other_user.stub(:calculate_weekly_score).and_return(90)
      user.update_scores
      other_user.update_scores
      user.daily_rank.should == 2
      user.weekly_rank.should == 1
    end

  end

  context "scores" do

    it "should return correct daily rank" do
      user1, user3, user2 = create(:user, daily_score: 20), create(:user, daily_score: 40), create(:user, daily_score: 30)
      user1.daily_rank.should == 3
      user3.daily_rank.should == 1
      user2.daily_rank.should == 2
    end

    it "should return correct weekly rank" do
      user1, user3, user2 = create(:user, weekly_score: 20), create(:user, weekly_score: 40), create(:user, weekly_score: 30)
      user1.weekly_rank.should == 3
      user3.weekly_rank.should == 1
      user2.weekly_rank.should == 2
    end

  end

  context "find_or_create_from_auth_hash" do

    it "must create a new user if no uid and provider match exists" do
      expect {
        user = User.find_or_create_from_auth_hash(uid: "u", provider: "p", info: {name: "Grant"})
        user.uid.should == 'u'
        user.provider.should == 'p'
        user.name.should == 'Grant'
      }.to change(User, :count).by(1)
    end

    it "must return existing user if uid and provider match exists" do
      user_id = create(:user, uid: "u1", provider: "p", name: "Pawel").id
      expect {
        user = User.find_or_create_from_auth_hash(uid: "u1", provider: "p", info: {name: "Pawel"})
        user.uid.should == 'u1'
        user.provider.should == 'p'
        user.id == user_id
      }.to change(User, :count).by(0)
    end

    it "must return nil if no uid" do
      User.find_or_create_from_auth_hash(uid: "", provider: "p", info: {name: "Grant"}).should be_nil
    end

    it "must return nil if no provider" do
      User.find_or_create_from_auth_hash(uid: "u", provider: "", info: {name: "Grant"}).should be_nil
    end

  end

end
