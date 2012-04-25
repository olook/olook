# -*- encoding: utf-8 -*-
namespace :facebook do
  desc "Set all users facebook_token to nil"
  task :set_users_facebook_token_to_nil, :needs => :environment do
    conn = ActiveRecord::Base.connection
    conn.execute("update users set facebook_token = NULL where facebook_token IS NOT NULL")
  end

  desc "Store user facebook attributes in csv a file"
  task :store_facebook_info, :filename, :needs => :environment do |t, args|
    @csv = CSV.generate do |rows|
      rows << %w{id uid facebook_token has_facebook_extended_permission}
      User.where('uid IS NOT NULL').each do |user|
        rows << [user.id, user.uid, user.facebook_token, user.has_facebook_extended_permission]
      end
    end
    File.open(args[:filename], 'w') {|f| f.write(@csv) }
  end

  desc "Restore facebook info from csv file with columns ['user_id', 'uid', 'facebook_token', 'has_facebook_extended_permission']"
  task :restore_facebook_info, :filename, :needs => :environment do |t, args|
    CSV.foreach(args[:filename], :headers => true) do |row| 
      puts row
      user = User.find(row[0])
      user.uid = row[1]
      user.facebook_token = row[2]
      user.save
    end
  end

  desc "Set all users uid to nil"
  task :set_users_facebook_uid_to_nil, :needs => :environment do
  	conn = ActiveRecord::Base.connection
    conn.execute("update users set uid = NULL where uid IS NOT NULL")
  end

end

