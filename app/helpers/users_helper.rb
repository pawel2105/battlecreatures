module UsersHelper

  def display_user_name(name)
    text = CGI::unescape(name)
    text.gsub!(".+","")
    text.gsub!(".-","")
    text.html_safe
  end

end
