module Search
  class Url

    def initialize(args={})
      @parameters = []
      @str_params = []
      @config = args.delete(:config)
      @base_url = @config["search_domain"] + "/2011-02-01/search"
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
