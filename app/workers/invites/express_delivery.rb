# -*- encoding : utf-8 -*-
require 'zipruby'
require 'net/ftp'

module Invites
  class ExpressDelivery
    @queue = :send_invites

    class << self    
      attr_reader :invites
    end

    def self.accept_invitation_url(params)
      Rails.application.routes.url_helpers.accept_invitation_url params, :host => 'olook.com.br'
    end

    def self.perform(invite_ids)
      Dir.mkdir(directory_name)
      
      render_file 'campanha'
      render_file 'html'
      @invites = Invite.includes(:user).where(:id => invite_ids)
      render_file 'email'
      
      zip_file = create_zip directory_name, ['campanha', 'html', 'email']
      send_file_via_ftp zip_file
    end

  protected    
    def self.send_file_via_ftp(file)
      Net::FTP.open('beta.olook.com.br') do |ftp|
        ftp.login 'allinmail', 'allinmail123abc'
        ftp.chdir('/home/allinmail')
        ftp.putbinaryfile(file)
      end
    end

    def self.create_zip(directory, files)
      dir = directory.split.last
      zip_file = directory.parent.join "#{dir}.zip"
      Zip::Archive.open(zip_file.to_s, Zip::CREATE) do |zip|
        zip.add_dir(dir.to_s)
        files.each do |file|
          zip.add_file("#{dir}/#{file}.txt", directory.join("#{file}.txt").to_s)
        end
      end
      raise unless File.exist?(zip_file)
      zip_file
    end

    def self.render_file(file_name)
      file_to_render = File.join(Rails.root, 'app', 'workers', 'invites', "#{file_name}.txt.erb")
      rendered = ERB.new(File.open(file_to_render).read).result(binding)
      File.open(File.join(directory_name, "#{file_name}.txt"), 'w+') do |file|
        file.write(rendered)
      end
    end

    def self.base_directory
      base_dir = Rails.root.join('tmp', 'send_invites', Rails.env)
      FileUtils.mkdir_p base_dir
      base_dir
    end

    def self.directory_name
      @directory_name ||= base_directory.join("invites_#{Time.now.strftime('%Y%m%d%H%M')}")
    end
  end
end
