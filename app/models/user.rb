class User < ActiveRecord::Base
  attr_accessor :user_agent, :language, :gender, :age, :country, :area
  attr_accessible :name, :provider, :uid, :daily_score, :weekly_score
  has_many :battles

  validates :provider, :uid, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  scope :today, lambda{ |amount| order('daily_score DESC').limit(amount) }
  scope :this_week, lambda{ |amount| order('weekly_score DESC').limit(amount) }

  def self.find_or_create_from_auth_hash(auth_hash)
    auth_hash.stringify_keys!
    logger.debug "Auth Login Attempt with: #{auth_hash.to_s}"
    return nil if auth_hash['uid'].blank? || auth_hash['provider'].blank?
    user = find_or_initialize_by_uid_and_provider(auth_hash['uid'],auth_hash['provider'])
    if auth_hash['info']
      auth_hash['info'].stringify_keys!
      user.name = auth_hash['info']['name']
      user.save!
    end
    return user
  end

  def calculate_daily_score
    battles.all(conditions: ["DATE(created_at) = DATE(?)", Time.now]).inject(0){|sum,battle| sum += battle.score.to_i }
  end

  def calculate_weekly_score
    battles.all(conditions: ["DATE(created_at) > DATE(?)", 7.days.ago]).inject(0){|sum,battle| sum += battle.score.to_i }
  end

  def update_scores
    update_attributes(daily_score: calculate_daily_score, weekly_score: calculate_weekly_score)
  end

  def daily_rank
    @score = self.daily_score
    User.where("daily_score > ?", @score).count + 1
  end

  def weekly_rank
    @score = self.weekly_score
    User.where("weekly_score > ?", @score).count + 1
  end

end
