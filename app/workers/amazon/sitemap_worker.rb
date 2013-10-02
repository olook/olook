require 'rake'
Olook::Application.load_tasks

class SitemapWorker
  @queue = :sitemap

  def self.perform
    Rake::Task["sitemap:refresh"].invoke
  end
end
