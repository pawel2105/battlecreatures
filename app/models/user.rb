class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  validates :provider, :uid, presence: true
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_or_create_from_auth_hash(auth_hash)
    auth_hash.stringify_keys!
    logger.debug "Auth Login Attempt with: #{auth_hash.to_s}"
    return nil if auth_hash['uid'].blank? || auth_hash['provider'].blank?
    user = find_or_initialize_by_uid_and_provider(auth_hash['uid'],auth_hash['provider'])
    return user unless user.new_record?
    if auth_hash['info']
      auth_hash['info'].stringify_keys!
      user.name = auth_hash['info']['name']
      user.save!
    end
    return user
  end

end
