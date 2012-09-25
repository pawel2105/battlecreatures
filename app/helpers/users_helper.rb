module UsersHelper

  def display_user_name(name)
    mxit_markup(CGI::unescape(name))
  end

  def mxit_markup(text_markup)
    result = " #{text_markup}".gsub(/\.[\+\-]/,"").gsub(/[^\\]\*.+[^\\]\*/) do |text|
      "<b>#{text.gsub("*","")}</b>"     # Bold Text
    end.gsub(/[^\\]\/.+[^\\]\//) do |text|
      "<i>#{text.gsub("/","")}</i>"    # Italics Text
    end.gsub(/[^\\]_.+[^\\]_/) do |text|
      "<u>#{text.gsub("_","")}</u>"    # Underline Text
    end.gsub(/(#[A-F0-9]{6})/,""). # remove color
      gsub(/[^\\]\$.+[^\\]\$/) do |text|
      text.gsub("$","")               # remove $
    end.squish
    result.html_safe
  end

end
