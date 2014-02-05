# -*- encoding : utf-8 -*-
WORDPRESS_XML_RPC_CONFIG = YAML.load_file("#{Rails.root}/config/wordpress-xml-rpc.yml")
POST_RETRIEVER_SERVICE = PostRetrieverService.new(WORDPRESS_XML_RPC_CONFIG['host'], WORDPRESS_XML_RPC_CONFIG['path'], WORDPRESS_XML_RPC_CONFIG['login'], WORDPRESS_XML_RPC_CONFIG['password'])