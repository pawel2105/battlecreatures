class Game < ActiveRecord::Base
  belongs_to :user
  attr_accessible :choices, :word, :user_id

  validates :word, :user_id, presence: true
end
