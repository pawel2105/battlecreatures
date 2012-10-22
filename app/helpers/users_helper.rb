module UsersHelper

  def display_user_name(name)
    return "" if name.blank?
    mxit_markup(CGI::unescape(name))
  end

  def mxit_markup(text_markup)
    result = " #{text_markup}".gsub(/\.[\+\-]/,"").gsub(/\/.+[^\\]\//) do |text|
      "<i>#{text.gsub("/","")}</i>"       # Italics Text
    end.gsub(/(#[a-fA-F0-9]{6})([^#\z]+)/) do |text|
      match_data = /(#[a-fA-F0-9]{6})([^#\z]+)/.match(text)
      "<span style='color:#{match_data[1]}'>#{match_data[2]}</span>" # color text
    end.gsub(/\*.+[^\\]\*/) do |text|
      "<b>#{text.gsub("*","")}</b>"       # Bold Text
    end.gsub(/_.+[^\\]_/) do |text|
      "<u>#{text.gsub("_","")}</u>"       # Underline Text
    end.gsub(/\$.+[^\\]\$/) do |text|
      text.gsub("$","")                   # remove $
    end.squish
    result.html_safe
  end

end
