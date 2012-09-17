require 'spec_helper'
require 'cancan/matchers'

describe Ability do


  before :each do
    @user = create(:user)
    @ability = Ability.new(@user)
  end

  context "Battles" do

    it "must be able to view battles" do
      @ability.should be_able_to(:read, Battle)
    end

    # it "wont be able to read other users battles" do
    #   battle = create(:battle, user: create(:user))
    #   @ability.should_not be_able_to(:read, battle)
    # end

    it "must be able to read own users battles" do
      battle = create(:battle, user: @user)
      @ability.should be_able_to(:read, battle)
    end

    it "must be able to create battles" do
      @ability.should be_able_to(:create, Battle)
    end

    # it "wont be able to play letters on other users battles" do
    #   battle = create(:battle, user: create(:user))
    #   @ability.should_not be_able_to(:enter_battle, battle)
    # end

    it "must be able to play letters on own users battles" do
      battle = create(:battle, user: @user)
      @ability.should be_able_to(:enter_battle, battle)
    end

  end


end