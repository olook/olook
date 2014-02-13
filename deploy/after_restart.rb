notifies :restart, 'service[site_resque]' if File.exist?('/etc/init/site_resque.conf')
