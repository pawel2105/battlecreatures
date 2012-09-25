# encoding: utf-8
require 'spec_helper'

describe 'words' do

  before :each do
    @current_user = create(:user, uid: 'm2604101', provider: 'mxit')
    add_headers('X_MXIT_USERID_R' => 'm2604101')
    @body = %~<table class="ts"><tbody><tr><td valign="top" width="80px" style="padding-bottom:5px;padding-top:5px;color:#666">Adverb:</td><td valign="top" style="padding-bottom:5px;padding-top:5px"><table class="ts"><tbody><tr><td><ol style="padding-left:19px"><li style="list-style-type:decimal">In or after a short time:  "he'll be home soon".</li><li style="list-style-type:decimal">Early:  "it was too soon to know".</li></ol></td></tr></tbody></table></td></tr><tr height="1px" bgcolor="#ddd"><td height="1px" colspan="2"></td></tr><tr><td valign="top" width="80px" style="padding-bottom:5px;padding-top:5px;color:#666">Synonyms:</td><td valign="top" style="padding-bottom:5px;padding-top:5px"><div>shortly - early - presently - anon - before long</div></td></tr></tbody></table>~
  end

  it "must allow to look up definition of the word" do
    stub_request(:get, "https://www.google.com/search?q=define%20today").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us)'}).
      to_return(:status => 200, :body => @body, :headers => {})
    create(:won_game, word: "today", user: @current_user)
    visit '/'
    click_link 'show'
    click_link 'define_word'
    page.should have_content("Defining: today")
    page.should have_link('new_game')
  end

end