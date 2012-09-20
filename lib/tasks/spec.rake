begin
  require 'rspec/core/rake_task'

  desc "Run specs that are used for coverage"
  RSpec::Core::RakeTask.new('spec:unit') do |task|
    task.pattern = ["**/controllers/*_spec.rb","**/models/*_spec.rb","**/helpers/*_spec.rb","**/routing/*_spec.rb","**/mailers/*_spec.rb","**/lib/*_spec.rb"]
    task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
  end

  desc "Run units tests"
  RSpec::Core::RakeTask.new('spec:units') do |task|
    task.pattern = ["**/controllers/*_spec.rb","**/models/*_spec.rb","**/helpers/*_spec.rb","**/routing/*_spec.rb","**/mailers/*_spec.rb","**/views/*/*_spec.rb"]
    task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
  end
rescue LoadError
  # this allows heroku to run rake tasks
end

