require 'spec_helper'

describe Dictionary do

  before :each do
    Dictionary.clear
  end

  context "adding words" do

    it "must have a value" do
      expect{Dictionary << ""}.to_not change(Dictionary,:size)
      expect{Dictionary.add("")}.to_not change(Dictionary,:size)
    end

    it "must have a unique value" do
      expect{Dictionary << "test"}.to change(Dictionary,:size)
      expect{Dictionary << "test"}.to_not change(Dictionary,:size)
    end

    it "must only contain letters" do
      expect{Dictionary << "qwertyuiopasdfghjklzxcvbnm"}.to change(Dictionary,:size)
    end

    it "wont contain numbers" do
      expect{Dictionary << "he11o"}.to_not change(Dictionary,:size)
    end

    it "wont contain other characters" do
      expect{Dictionary << "goodbye!"}.to_not change(Dictionary,:size)
      expect{Dictionary << "g**d"}.to_not change(Dictionary,:size)
    end

    it "wont have least than 4 letters" do
      expect{Dictionary << "day"}.to_not change(Dictionary,:size)
      expect{Dictionary << "love"}.to change(Dictionary,:size)
    end

  end

  it "must lower case the text when adding" do
    expect{Dictionary << "Birthday"}.to change(Dictionary,:size)
    Dictionary.should be_member("birthday")
  end

  it "must return a random word" do
    Dictionary.clear
    expect{Dictionary << "hello"}.to change(Dictionary,:size)
    expect{Dictionary << "goodbye"}.to change(Dictionary,:size)
    ["hello","goodbye"].should include(Dictionary.random_value)
  end

  it "must return a random word even if no words in database" do
    Dictionary.clear
    Dictionary.random_value.should == "missing"
  end

  it "must empty the dictionary" do
    Dictionary.clear.size.should == 0
  end

end
