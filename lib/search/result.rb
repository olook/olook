# -*- encoding : utf-8 -*-
require 'json'
module Search
  class Result
    def self.factory
      eval("#{Search::Config.api_version_module_name}::Result")
    end
  end
end
