class User < ActiveRecord::Base
  attr_accessible :name, :provider, :uid

  validates :provider, :uid, presence: true
  validates_uniqueness_of :uid, :scope => :provider
end
