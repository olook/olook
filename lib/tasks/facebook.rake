# -*- encoding: utf-8 -*-
namespace :facebook do
  desc "Set all users facebook_token to nil"
  task :set_users_facebook_token_to_nil => :environment do
    conn = ActiveRecord::Base.connection
    conn.execute("update users set facebook_token = NULL where facebook_token IS NOT NULL")
  end
end

