require 'spec_helper'

describe Word do

  context "Validation" do

    it "must have a value" do
      Word.new.should have(1).errors_on(:value)
      Word.new(value: 'xx').should have(0).errors_on(:value)
    end

    it "must have a unique value" do
      create(:word, value: "test")
      Word.new(value: 'test').should have(1).errors_on(:value)
    end

    it "must only contain letters" do
      Word.new(value: 'qwertyuiopasdfghjklzxcvbnm').should have(0).errors_on(:value)
      Word.new(value: 'he11o').should have(1).errors_on(:value)
      Word.new(value: 'goodbye!').should have(1).errors_on(:value)
      Word.new(value: 'g**d').should have(1).errors_on(:value)
    end

  end

  it "lowercases the text before validation" do
    word = Word.new(value: "Hello")
    word.valid?
    word.value.should == "hello"
  end

  it "must return a random word" do
    create(:word, value: "hello")
    create(:word, value: "goodbye")
    ["hello","goodbye"].should include(Word.random_value)
  end

  it "must return a random word even if know words in database" do
    Word.random_value.should == "missing"
  end

end
