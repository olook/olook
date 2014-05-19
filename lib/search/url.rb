require 'config'
module Search
  class Url

    def initialize(args={})
      @parameters = []
      @str_params = []
      @base_url = File.join(Search::Config["search_domain"], Search::Config['api_version'], 'search')
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
      "http://#{@base_url}?#{params.join('&')}"
    end
  end
end
