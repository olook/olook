role :app, ""184.73.85.148
 
set :files_repo, "/sandbox/Olook/config_files"
# server details
set :rails_env, "RAILS_ENV=production"

# repo details
set :branch, 'master'

# tasks
namespace :deploy do
  task :setup, :role => :app do
    run <<-CMD
      puts "Update && Upgrade"
      aptitude update
      aptitude upgrade -y
      
      cat ~/.ssh/id_rsa.pub | ssh -i .ssh/default_key.pem ubuntu@#{:app} "cat >> /root/.ssh/authorized_keys"
      scp sshd => new_machine
      /etc/init.d/ssh restart

      aptitude install fail2ban -y

      scp jail.conf /etc/fail2ban/
      /etc/init.d/fails2ban restart
      iptables -nL
      sleep 5

      puts "Installing packege dependencies"
      apt-get -y install gcc g++ build-essential libssl-dev libreadline-gplv2-dev zlib1g-dev linux-headers-generic libsqlite3-dev bison autoconf graphicsmagick-imagemagick-compat libxml2-dev libxslt-dev libcurl3-openssl-dev libmysqlclient-dev libyaml-dev  libpcre3-dev
      sleep 5

      puts "Compiling ruby"
      cd /usr/src
      wget http://ftp.ruby-lang.org/pub/ruby/ruby-1.9-stable.tar.gz
      tar -zxvf ruby-1.9-stable.tar.gz
      cd ruby-1.9.2-p290/
      ./configure --prefix=/usr/local/ruby
      make && make install
      echo PATH="$PATH:/usr/local/ruby/bin:/usr/local/ruby/lib/ruby/gems/1.9.1/bin" > /etc/environment
      source /etc/environment
      gem update --system

      gem install bundler

      ruby -v
      sleep 5

      puts "Compiling NGINX"
      cd /usr/src
      wget http://nginx.org/download/nginx-1.2.2.tar.gz
      tar -zxvf nginx-1.2.2.tar.gz
      cd nginx-1.2.2/
      #./configure --with-http_ssl_module --prefix=/usr/local/nginx --with-http_gzip_static_module
      ./configure --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-debug --with-http_addition_module --with-http_gzip_static_module --with-http_realip_module --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-sha1=/usr/include/openssl --with-md5=/usr/include/openssl
      make && make install

      puts "Configurando upstart do Nginx e Unicorn"
      scp -P 13630 #{:files_repo}/etc/init/unicorn.conf root@#{:app}:/etc/init/
      scp -p 13630 #{:files_repo}/etc/init/nginx.conf root@#{:app}:/etc/init/

      puts "Config do Nginx"
      scp -P 13630 #{:files_repo}/usr/local/nginx/conf/nginx.conf root@#{:app}:/usr/local/nginx/conf/
      start nginx
    CMD
  end
end
