notifies :restart, 'service[site_resque]' if File.exists?('/etc/init/site_resque.conf')
