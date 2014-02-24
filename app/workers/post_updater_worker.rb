# -*- encoding : utf-8 -*-
class PostUpdaterWorker
  @queue = 'blog_posts'

  def self.perform
    POST_RETRIEVER_SERVICE.gather_posts
  end
end
