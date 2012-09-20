class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid, :weekly_rating, :monthly_rating, :yearly_rating

  has_many :games

  validates :provider, :uid, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  scope :top_this_week, lambda{ |amount| order('weekly_rating DESC').limit(amount) }
  scope :top_this_month, lambda{ |amount| order('monthly_rating DESC').limit(amount) }

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

  def calculate_weekly_rating
    games.this_week.top(20).inject(0){|sum,game| sum += game.score.to_i }
  end

  def calculate_monthly_rating
    games.this_month.top(80).inject(0){|sum,game| sum += game.score.to_i }
  end

  def calculate_yearly_rating
    games.this_year.top(960).inject(0){|sum,game| sum += game.score.to_i }
  end

  def update_ratings
    update_attributes(weekly_rating: calculate_weekly_rating,
                      monthly_rating: calculate_monthly_rating,
                      yearly_rating: calculate_yearly_rating)
  end

  def weekly_rank
    User.where("weekly_rating > ?", weekly_rating).count + 1
  end

  def monthly_rank
    User.where("monthly_rating > ?", monthly_rating).count + 1
  end

  def yearly_rank
    User.where("yearly_rating > ?", yearly_rating).count + 1
  end

  def game_count
    games.count
  end

end
