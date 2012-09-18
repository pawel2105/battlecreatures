class Game < ActiveRecord::Base
  belongs_to :user
  attr_accessible :choices, :word, :user_id

  validates :word, :user_id, presence: true

  def select_random_word
    self.word = Word.random_value
  end

end
