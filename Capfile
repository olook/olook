gemfile = File.expand_path(File.join(__FILE__, '..', 'Gemfile'))
if File.exist?(gemfile) && ENV['BUNDLE_GEMFILE'].nil?
  puts "Respawning with 'bundle exec'"
  exec("bundle", "exec", "cap", *ARGV)
end

load 'deploy' if respond_to?(:namespace) # cap2 differentiator

env = ENV['RUBBER_ENV'] ||= (ENV['RAILS_ENV'] || 'staging')
root = File.dirname(__FILE__)

if env == 'production'
  puts "\e[1;31mYou are going to deploy in production! Are you sure?(y/N)\e[0m"
  ans = STDIN.gets.strip
  exit if ans !~ /^y$/i
end

# this tries first as a rails plugin then as a gem
$:.unshift "#{root}/vendor/plugins/rubber/lib/"
require 'rubber'

Rubber::initialize(root, env)
require 'rubber/capistrano'

Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
