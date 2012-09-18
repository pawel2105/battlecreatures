class Word < ActiveRecord::Base
  attr_accessible :value

  validates :value, presence: true, uniqueness: true, format: /^\p{Lower}*$/

  before_validation :downcase_value

  scope :random, order("RANDOM()")

  def self.random_value
    random.first.try(:value) || "missing"
  end

  protected

  def downcase_value
    value.downcase! if value
  end

end
