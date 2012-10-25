class Battle < ActiveRecord::Base
  belongs_to :user
  attr_accessible :choices, :opponent, :user_id
 
  after_create :select_random_opponent, :outcome
  before_save :set_score
  after_save :update_user_score, :delete_old_battles

  scope :this_week, lambda{ where('created_at > ?',Time.current.beginning_of_week) }
  scope :today, lambda{ where('created_at > ?',Time.current.beginning_of_day) }

  def select_random_opponent
    self.opponent = ["vampire","zombie","robot","ninja","pirate"].sample
    self.update_attributes(opponent: self.opponent)
  end

  def outcome
    if self.choices == "pirate" && (self.opponent == "robot" || self.opponent == "vampire")
      return "win"
    elsif self.choices == "pirate" && self.opponent == "pirate"
      return "draw"
    elsif self.choices == "pirate" && (self.opponent == "zombie" || self.opponent == "ninja")
      return "lose"
    elsif self.choices == "zombie" && (self.opponent == "pirate" || self.opponent == "vampire")
      return "win"
    elsif self.choices == "zombie" && self.opponent == "zombie"
      return "draw"
    elsif self.choices == "zombie" && (self.opponent == "robot" || self.opponent == "ninja")
      return "lose"
    elsif self.choices == "ninja" && (self.opponent == "zombie" || self.opponent == "pirate")
      return "win"
    elsif self.choices == "ninja" && self.opponent == "ninja"
      return "draw"
    elsif self.choices == "ninja" && (self.opponent == "robot" || self.opponent == "vampire")
      return "lose"
    elsif self.choices == "robot" && (self.opponent == "zombie" || self.opponent == "ninja")
      return "win"
    elsif self.choices == "robot" && self.opponent == "robot"
      return "draw"
    elsif self.choices == "robot" && (self.opponent == "pirate" || self.opponent == "vampire")
      return "lose"
    elsif self.choices == "vampire" && (self.opponent == "robot" || self.opponent == "ninja")
      return "win"
    elsif self.choices == "vampire" && self.opponent == "vampire"
      return "draw"
    elsif self.choices == "vampire" && (self.opponent == "zombie" || self.opponent == "pirate")
      return "lose"
    else
      return "wrong choice"
    end 
  end

  def set_score
    if self.outcome == "win"
      self.score = 1
    elsif self.outcome == "draw"
      self.score = 0
    elsif self.outcome == "lose"
      self.score = -1
    else
      nil
    end 
  end

  def self.description
    ["The fight was short but intense.", "You faught bravely.", "Howls, cuts, bites.",
     "The battle raged for hours.", "It was a quick battle.", "Many creatures watched.",
     "The fighting was heard from afar.", "Strong blows, agile moves.", "You faced a mighty opponent",
     "A crowd gathered for the battle", "Movies will be made about this battle."].sample
  end

  protected

  def update_user_score
    user.update_scores
  end

  def delete_old_battles
    user.battles.where(["created_at < ?", 3.days.ago]).each { |b| b.delete }
  end

end
