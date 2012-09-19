class Word < ActiveRecord::Base
  attr_accessible :value

  validates :value, uniqueness: true, format: /^\p{Lower}*$/, length: { :minimum => 4 }

  before_validation :downcase_value, :remove_spaces

  scope :random, order("RANDOM()")

  def self.random_value
    random.first.try(:value) || "missing"
  end

  protected

  def downcase_value
    value.downcase! if value
  end

  def remove_spaces
    value.gsub!(/\s/,"") if value
  end

end
