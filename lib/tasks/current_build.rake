desc "Discover current build running on production."
task :current_build do
  get_info = `dpkg -l | grep olook | awk '{ print $3 }'`.chomp
  puts get_info
end
