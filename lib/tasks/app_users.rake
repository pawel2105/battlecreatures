namespace :app do

  namespace :users do
    desc "Purge old user battles"
    task :purge_battles => :environment do
      Battle.where(["created_at < ?", 1441.minutes.ago]).each { |b| b.delete }
      puts "Old battles have been removed"
    end
  end

end