Rails.configuration.log_tags = [
  :remote_ip,
  lambda {|req| "#{req.session_options[:id]}" },
  proc do |req|
    if req.session["warden.user.user.key"].nil?
      "Anonym"
    else
      "user_id:#{req.session["warden.user.user.key"][1][0]}"
    end
  end
]
