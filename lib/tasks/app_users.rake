namespace :app do

  namespace :users do
    desc "Update user ratings"
    task :update_rating => :environment do
      User.all.each do |user|
        if user.update_ratings
          print "\e[32m.\e[0m"
        else
          print "\e[31mF\e[0m"
        end
        $stdout.flush
      end
      puts
    end
  end

end