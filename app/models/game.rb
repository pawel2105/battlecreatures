class Game < ActiveRecord::Base
  ATTEMPTS = 9
  belongs_to :user
  attr_accessible :choices, :word, :user_id

  validates :word, :user_id, presence: true

  def select_random_word
    self.word = Word.random_value
  end

  def add_choice(letter)
    self.choices ||= ""
    return if has_no_attempts_left? || letter.to_s.size > 1
    letter.downcase!
    self.choices << letter if letter =~ /\p{Lower}/
  end

  def attempts_left
    Game::ATTEMPTS - attempts
  end

  def attempts
    (choices.to_s.split("") - word.split("")).size
  end

  def has_attempts_left?
    attempts_left > 0
  end

  def has_no_attempts_left?
    !has_attempts_left?
  end

end
