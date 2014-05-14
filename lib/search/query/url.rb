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
        args.each do |k, v|
          if args[k].respond_to?(:query_url)
            @parameters << args.delete(k) if args[k]
          else
            @str_params << "#{k}=#{v}"
          end
        end
      end

      def url
        params = @parameters.map do |param|
          param.query_url
        end
        params.flatten!
        params.reject! { |p| p.nil? || p == '' }
        params.concat(@str_params)
        "http://#{BASE_URL}?#{params.join('&')}"
      end
    end
  end
end
