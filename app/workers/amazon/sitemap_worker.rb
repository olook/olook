require 'rake'
Olook::Application.load_tasks

class SitemapWorker
  @queue = 'low'

  def self.perform
    Rake::Task["sitemap:refresh"].invoke
  end
end
