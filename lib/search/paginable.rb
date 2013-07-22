module Search
  module Paginable
    # define this method where you are gonna use this mixin
    def total_results
    end

    def for_page page
      @current_page = (page || 1).to_i
      self
    end

    def current_page
      @current_page
    end

    def next_page
      @current_page + 1
    end

    def previous_page
      @current_page - 1
    end

    def start_product
      @limit ? (@current_page - 1) * @limit : 0
    end

    def with_limit limit
      @limit = limit
      self
    end

    def pages
      (total_results / @limit.to_f).ceil
    end

    def next_pages
      _page = @current_page
      _pages = []
      2.times do |page|
        page = _page + 1
        _pages << page
        _page = _page + 1
      end
      _pages.delete_if {|v| v >= self.pages}
    end

    def previous_pages
      _page = @current_page
      _pages = []
      2.times do |page|
        page = _page - 1
        _pages << page
        _page = _page - 1
      end
      _pages.reverse.delete_if {|v| v <= 0}
    end

    def current_page_greater_than_limit_link_pages?
      @current_page > 4
    end

    def current_page_greater_or_eq_than_limit_link_pages?
      @current_page >= 4
    end

    def last_three_pages
      @current_page - 3
    end

    def next_three_pages
      @current_page + 3
    end

    def has_next_page?
      @current_page.to_i < self.pages
    end

    def has_previous_page?
      @current_page.to_i > 1
    end

    def has_at_least_three_more_pages?
      @current_page < (self.pages - 3)
    end
  end
end
