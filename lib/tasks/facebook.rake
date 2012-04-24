# -*- encoding: utf-8 -*-
namespace :facebook do
  desc "Set all users facebook_token to nil"
  task :set_users_facebook_token_to_nil, :needs => :environment do
    conn = ActiveRecord::Base.connection
    conn.execute("update users set facebook_token = NULL where facebook_token IS NOT NULL")
  end

  desc "Store user facebook attributes in a file"
  task :store_facebook_info, :filename, :needs => :environment do |t, args|
    @csv = CSV.generate do |rows|
      rows << %w{id uid facebook_token has_facebook_extended_permission}
      User.where('uid IS NOT NULL').each do |user|
        rows << [user.id, user.uid, user.facebook_token, user.has_facebook_extended_permission]
      end
    end
    File.open(args[:filename], 'w') {|f| f.write(@csv) }
  end

  desc "Set all users uid to nil"
  task :set_users_facebook_uid_to_nil, :needs => :environment do
  	conn = ActiveRecord::Base.connection
    conn.execute("update users set uid = NULL where uid IS NOT NULL")
  end

end

