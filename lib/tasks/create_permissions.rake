desc "Create Permissions for Controllers"
namespace :olook do
  task :create_permissions, :needs => :environment do
    controllers = Dir.new("#{Rails.root}/app/controllers/admin").entries
    controllers.each do |controller|
        if controller =~ /_controller/
          controller_name = controller.camelize.gsub(".rb","")
          permissions = (eval("Admin::#{controller_name}.new.methods") - Object.methods - ApplicationController.new.methods).sort
          permissions.reject! { |method| method =~ /_one_time_conditions/  || method =~ /_callback_before/ }
          permissions.each  {|action|
            name_short = controller_name.gsub("Controller","").camelize.singularize
            Permission.create(:model_name => name_short, :action_name => action)
           puts "#{action} and #{name_short}"}
        end
    end
  end
end
