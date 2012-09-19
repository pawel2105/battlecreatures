class Game < ActiveRecord::Base
  ATTEMPTS = 10
  belongs_to :user
  attr_accessible :choices, :word, :user_id

  validates :word, :user_id, presence: true

  after_validation do |record|
    record.completed = record.done?
  end

  scope :active_first, order('completed ASC, created_at DESC').where('completed IS NOT NULL')


  def select_random_word
    self.word = Word.random_value
  end

  def add_choice(letter)
    self.choices ||= ""
    return if is_lost? || letter.to_s.size > 1
    letter.downcase!
    self.choices += letter if letter =~ /\p{Lower}/
  end

  def attempts_left
    Game::ATTEMPTS - attempts
  end

  def attempts
    (choices.to_s.split("") - word.to_s.split("")).size
  end

  def has_attempts_left?
    attempts_left > 0
  end

  def hangman_text
    return word if done?
    text = word
    word.split("").each{|letter| text.gsub!(letter,"_") unless choices.to_s.include?(letter)}
    text
  end

  def done?
    is_lost? || is_won?
  end

  def is_won?
    (word.to_s.split("") - choices.to_s.split("")).empty?
  end

  def is_lost?
    !has_attempts_left?
  end


end
