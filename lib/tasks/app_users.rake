namespace :app do

  namespace :users do
    desc "Purge old user battles"
    task :purge_battles => :environment do
      @initial_battles = Battle.count
      Battle.where(["created_at < ?", 1441.minutes.ago]).each { |b| b.delete }
      @battles_left = Battle.count - @initial_battles
      puts "#{@battles_left} Old battles have been removed"
    end

    desc "Purge inactive users"
    task :purge_users => :environment do
    	@initial_users = User.count
      User.where(["updated_at < ?", 1441.minutes.ago]).each { |b| b.delete }
      @users_left = User.count - @initial_users
      puts "Old users have been removed"
    end
  end

end