module Search
  module Query
    class Url
      SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
      BASE_URL = SEARCH_CONFIG["search_domain"] + "/2011-02-01/search"

      def initialize(args={})
        @parameters = []
        @str_params = []
        set_params(args)
      end

      def set_params(args)
        [:facets, :structured, :term, :sort].each do |k|
          @parameters << args.delete(k) if args[k] && args[k].respond_to?(:to_param)
        end
        args.each do |k, v|
          @str_params << "#{k}=#{v}"
        end
      end

      def url
        params = @parameters.map do |param|
          param.to_param
        end
        params.flatten!
        params.concat(@str_params)
        "http://#{BASE_URL}?#{params.join('&')}"
      end
    end
  end
end
