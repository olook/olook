require 'yaml'
module Search
  def self.config &block
    if block
      block.call(Search::Config)
    else
      Search::Config
    end
  end
end

module Search
  class Config
    @@config ||= {}
    def self.[]=(key, val)
      @@config[key.to_s] = val
    end

    def self.[](key)
      @@config[key.to_s]
    end

    def self.load_config(file, env='production')
      @@config.merge!(YAML.load_file(file)[env])
    end

    def self.method_missing(m, *args, &block)
      if /(?<met_name>\w+)=/ =~ m.to_s
        @@config[met_name] = args.first
      else
        @@config[m.to_s]
      end
    end
  end
end
