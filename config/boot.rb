# -*- encoding : utf-8 -*-
require 'rubygems'
exts = $:.select { |l| File.exists?(File.expand_path(File.join(l, '../ext'))) }.
    map { |l| File.expand_path(File.join(l, 'usr/local/lib/ruby/site_ruby/2.0.0/x86_64-linux')) }
$:.concat(exts)

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
