require 'spec_helper'
require 'cancan/matchers'

describe Ability do


  before :each do
    @user = create(:user)
    @ability = Ability.new(@user)
  end

  context "Games" do

    it "must be able to view games" do
      @ability.should be_able_to(:read, Game)
    end

    it "wont be able to read other users games" do
      game = create(:game, user: create(:user))
      @ability.should_not be_able_to(:read, game)
    end

    it "must be able to read own users games" do
      game = create(:game, user: @user)
      @ability.should be_able_to(:read, game)
    end

    it "must be able to create games" do
      @ability.should be_able_to(:create, Game)
    end

    it "wont be able to play letters on other users games" do
      game = create(:game, user: create(:user))
      @ability.should_not be_able_to(:play_letter, game)
    end

    it "must be able to play letters on own users games" do
      game = create(:game, user: @user)
      @ability.should be_able_to(:play_letter, game)
    end

  end


end