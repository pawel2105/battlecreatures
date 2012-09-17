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

end
