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

if env == 'staging'
  machines = YAML::load( File. read File.expand_path( File.join( File.dirname(__FILE__), './config/rubber/instance-staging.yml' ) ) )
  options =  machines.map { |r| r.name rescue nil }.compact.inject( {} ) { |h, i| h[i] = i; h }
  options.merge!({ 'hmg' => 'homolog', 'dev' => 'development', 'all' => '' })
  filter = ENV['FILTER']
  if options[ARGV.last]
    filter ||= ARGV.pop
  end
  if !options[filter]
    str_opts = options.map{ |k,v| k == v ? k : "#{k}(#{v})" }.join('|')
    puts "\e[1;31mYou have not specified the machine to deploy!\e[0m"
    puts "\e[1;31mTell me the host to deploy: (#{str_opts})\e[0m"
    filter = STDIN.gets.strip
    if !options[filter]
      puts("Input (#{ans.inspect}) does not belongs to options (#{str_opts}). Exiting")
      exit
    end
  end

  ENV['FILTER'] = options[filter] || filter
end

Rubber::initialize(root, env)
require 'rubber/capistrano'


Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
