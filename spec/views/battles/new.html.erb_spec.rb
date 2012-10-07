require 'spec_helper'

describe "battles/new" do
  before(:each) do
    assign(:battle, stub_model(Battle).as_new_record)
  end

  it "renders new battle form" do
    render
    rendered.should have_content('Choose a pirate')
    rendered.should have_content('Choose a vampire')
    rendered.should have_content('Choose a ninja')
    rendered.should have_content('Choose a zombie')
    rendered.should have_content('Choose a robot')
  end
end
