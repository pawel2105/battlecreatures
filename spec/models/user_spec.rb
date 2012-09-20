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

  it "must return the amount of games" do
    user = create(:user)
    user.game_count.should == 0
    create(:game, user: user)
    user.game_count.should == 1
    create_list(:game,5, user: user)
    user.game_count.should == 6
  end

  context "calculate_weekly_rating" do

    it "must use 20 games in the last week" do
      user = create(:user)
      create_list(:won_game, 21,  score: 1, user: user)
      user.calculate_weekly_rating.should == 20
    end

    it "must use games only from this week" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.week.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_weekly_rating.should == 20
    end

    it "must use top scoring games in the last week" do
      user = create(:user)
      create_list(:won_game, 20,  score: 1, user: user)
      create(:won_game, score: 21, user: user)
      user.calculate_weekly_rating.should == 40
    end

  end

  context "calculate_monthly_rating" do

    it "must use 80 games in the last month" do
      user = create(:user)
      create_list(:won_game, 81,  score: 1, user: user)
      user.calculate_monthly_rating.should == 80
    end

    it "must use games only from this month" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.month.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_monthly_rating.should == 20
    end

    it "must use top scoring games in the last week" do
      user = create(:user)
      create_list(:won_game, 80,  score: 1, user: user)
      create(:won_game, score: 21, user: user)
      user.calculate_monthly_rating.should == 100
    end

  end

  context "calculate_yearly_rating" do

    it "must use 960 games in the last month" do
      user = create(:user)
      create_list(:won_game, 961,  score: 1, user: user)
      user.calculate_yearly_rating.should == 960
    end

    it "must use games only from this year" do
      user = create(:user)
      create(:won_game, score: 20, user: user)
      Timecop.freeze(1.year.ago - 1.day) do
        create(:won_game, score: 20, user: user)
      end
      user.calculate_yearly_rating.should == 20
    end

    it "must use top scoring games in the last year" do
      user = create(:user)
      create_list(:won_game, 960,  score: 1, user: user)
      create(:won_game, score: 41, user: user)
      user.calculate_yearly_rating.should == 1000
    end

  end

  context "calculate_score" do

    it "must update the ratings" do
      user = stub_model(User)
      user.stub(:calculate_weekly_rating).and_return(20)
      user.stub(:calculate_monthly_rating).and_return(80)
      user.stub(:calculate_yearly_rating).and_return(960)
      user.should_receive(:update_attributes).with(weekly_rating: 20, monthly_rating: 80, yearly_rating: 960)
      user.update_ratings
    end

  end

  context "rank" do

    it "should return correct weekly rank" do
      user1, user3, user2 = create(:user, weekly_rating: 20), create(:user, weekly_rating: 40), create(:user, weekly_rating: 30)
      user1.weekly_rank.should == 3
      user3.weekly_rank.should == 1
      user2.weekly_rank.should == 2
    end

    it "should return correct monthly rank" do
      user1, user3, user2 = create(:user, monthly_rating: 20), create(:user, monthly_rating: 40), create(:user, monthly_rating: 30)
      user1.monthly_rank.should == 3
      user3.monthly_rank.should == 1
      user2.monthly_rank.should == 2
    end

    it "should return correct yearly rank" do
      user1, user3, user2 = create(:user, yearly_rating: 20), create(:user, yearly_rating: 40), create(:user, yearly_rating: 30)
      user1.yearly_rank.should == 3
      user3.yearly_rank.should == 1
      user2.yearly_rank.should == 2
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
      create(:user, uid: "u1", provider: "p", name: "Pawel")
      expect {
        user = User.find_or_create_from_auth_hash(uid: "u1", provider: "p", info: {name: "Grant"})
        user.uid.should == 'u1'
        user.provider.should == 'p'
        user.name.should == 'Pawel'
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
