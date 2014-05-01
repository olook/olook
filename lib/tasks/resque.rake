# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  desc "Clear pending tasks"
  task :clear => :environment do
    queues = Resque.queues
    queues.each do |queue_name|
      puts "Clearing #{queue_name}..."
      Resque.redis.del "queue:#{queue_name}"
    end

    puts "Clearing delayed..." # in case of scheduler - doesn't break if no scheduler module is installed
    Resque.redis.keys("delayed:*").each do |key|
      Resque.redis.del "#{key}"
    end
    Resque.redis.del "delayed_queue_schedule"

    puts "Clearing stats..."
    Resque.redis.set "stat:failed", 0
    Resque.redis.set "stat:processed", 0
  end

  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    require "resque/failure/multiple"
    require "resque/failure/airbrake"
    require "resque/failure/redis"

    Resque.redis = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]

    Resque::Failure::Airbrake.configure do |config|
      config.api_key = '7d489c216b28c67d36d16be815ae48b1'
      config.secure = true
    end

    Resque::Failure::Multiple.classes = [Resque::Failure::Redis, Resque::Failure::Airbrake]
    Resque::Failure.backend = Resque::Failure::Multiple

    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    #Resque::Scheduler.dynamic = true

    # The schedule doesn't need to be stored in a YAML, it just needs to
    # be a hash.  YAML is usually the easiest.
    Resque.schedule = YAML.load_file('config/resque_schedule.yml')

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
    # require 'jobs'
  end

end
