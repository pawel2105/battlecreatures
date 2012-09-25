# Holds all the words for the game
require 'open-uri'

class Dictionary < SortedSet

  def <<(value)
    super if valid_value?(value)
  end

  def add(value)
    super if valid_value?(value)
  end

  def clear
    @array = nil
    super
  end

  def self.instance
    @instance ||= self.new
  end

  def self.method_missing(m, *args, &block)
    if instance.respond_to?(m, *args, &block)
      instance.send(m,*args,&block)
    else
      super
    end
  end

  def self.respond_to?(m, *args, &block)
    super || instance.respond_to?(m,*args, &block)
  end

  def random_value
    (@array ||= self.to_a).sample || "missing"
  end

  def self.define(word)
    user_agent = 'Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us)'

    parse(open "https://www.google.com/search?q=define+#{word}", 'User-Agent' => user_agent)
  end

  private

  def valid_value?(value)
    value.present? && (value.downcase! || true) && (value.gsub!(/\s/,"") || true) && value.size >= 4 && value =~ /^\p{Lower}*$/
  end

  def self.parse html
    doc = Nokogiri::HTML html

    doc.css('.ts td').first.children.collect{|c| c.text}
  end

end