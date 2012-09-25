require 'spec_helper'

describe UsersHelper do
  # include UsersHelper

  context "mxit_markup" do

    it "removes .+ and .-" do
      mxit_markup(".+grant .-speelman").should == "grant speelman"
    end

    it "removes $" do
      mxit_markup("$grant$ $speelman$").should == "grant speelman"
    end

    it "must add <b> for *" do
      mxit_markup("grant *gavin* speelman").should == "grant<b> gavin</b> speelman"
    end

    it "wont add <b> for \\*" do
      mxit_markup("grant \\*gavin\\* speelman").should == "grant \\*gavin\\* speelman"
    end

    it "must add <i> for /" do
      mxit_markup("grant /gavin/ speelman").should == "grant<i> gavin</i> speelman"
    end

    it "wont add <i> for \\/" do
      mxit_markup("grant \\/gavin\\/ speelman").should == "grant \\/gavin\\/ speelman"
    end

    it "must add <u> for _" do
      mxit_markup("grant _gavin_ speelman").should == "grant<u> gavin</u> speelman"
    end

    it "wont add <u> for \\_" do
      mxit_markup("grant \\_gavin\\_ speelman").should == "grant \\_gavin\\_ speelman"
    end

    it "must remove color" do
      mxit_markup("grant #FF1493gavin #7FFF00speelman").should == "grant gavin speelman"
    end

  end

end