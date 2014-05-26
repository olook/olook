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
    @@config_file ||= nil
    @@config_env ||= nil
    def self.[]=(key, val)
      @@config[key.to_s] = val
    end

    def self.[](key)
      read_config_file_if_empty
      @@config[key.to_s]
    end

    def self.read_config_file_if_empty
      if @@config.size == 0
        read_config_file
      end
    end

    def self.read_config_file
      @@config = YAML.load_file(config_file)[config_env].merge(@@config)
    end

    def self.config_file
      if defined?(Rails)
        File.join(Rails.root, 'config', 'cloud_search.yml')
      else
        File.join('.', 'config', 'cloud_search.yml')
      end
    end

    def self.config_env
      if defined?(Rails)
        Rails.env
      else
        'production'
      end
    end

    def self.api_version_module_name
      "V#{self['api_version'].to_s.gsub('-', '')}"
    end

    def self.method_missing(m, *args, &block)
      if /(?<met_name>\w+)=/ =~ m.to_s
        self[met_name] = args.first
      else
        self[m.to_s]
      end
    end
  end
end
