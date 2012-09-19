require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new('spec:unit') do |task|
  task.pattern = ["**/controllers/*_spec.rb","**/models/*_spec.rb","**/helpers/*_spec.rb","**/routing/*_spec.rb","**/mailers/*_spec.rb","**/lib/*_spec.rb"]
  task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
end

desc "Run units tests"
RSpec::Core::RakeTask.new('spec:units') do |task|
  task.pattern = ["**/controllers/*_spec.rb","**/models/*_spec.rb","**/helpers/*_spec.rb","**/routing/*_spec.rb","**/mailers/*_spec.rb","**/views/*/*_spec.rb"]
  task.rspec_opts = Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
end

desc "Run Browser"
RSpec::Core::RakeTask.new('browser_specs') do |task|
  task.pattern = ["browser_spec/features/*_spec.rb"]
  task.rspec_opts = ["-fd"] + Dir.glob("[0-9][0-9][0-9]_*").collect { |x| "-I#{x}" }.sort
end
