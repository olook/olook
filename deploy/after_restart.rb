service "site_resque" do
  if ::File.exist?('/etc/init/site_resque.conf')
    action :restart
  else
    action :nothing
  end
end
