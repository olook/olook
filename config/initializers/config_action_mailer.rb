config_file = File.join(Rails.root, 'config', 'email.yml')

if File.exist?(config_file)
  Rails.logger.info "Loading e-mail configurations from #{config_file}"

  configurations = YAML::load(File.open(config_file))[Rails.env] || {}
  configurations.symbolize_keys!

  if configurations.empty?
    Rails.logger.info "There are no e-mail configurations for #{Rails.env} environment"
  else
    Rails.logger.info "Loading e-mail configurations for #{Rails.env} environment"

    Olook::Application.configure do
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = configurations.clone
      config.action_mailer.raise_delivery_errors = true
      config.action_mailer.perform_deliveries = true
    end

    configurations[:password] = "FILTERED"
    Rails.logger.info configurations
  end
else
  Rails.logger.info "No configuration file for e-mail"
end
