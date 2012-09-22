# Holds all the words for the game
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

  private

  def valid_value?(value)
    value.present? && (value.downcase! || true) && (value.gsub!(/\s/,"") || true) && value.size >= 4 && value =~ /^\p{Lower}*$/
  end

end