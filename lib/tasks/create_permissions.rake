desc "Create Permissions for Controllers"
namespace :olook do
  task :create_permissions, :needs => :environment do
    controllers = Dir.new("#{Rails.root}/app/controllers/admin").entries
    models_rb_files = File.join("#{Rails.root}/app/models/**", "*.rb")
    models = Dir.glob(models_rb_files)
    models.collect! {|model| model.gsub!(/(\/.*\/)/, "").camelize.gsub!(".rb", "")}
    controllers.each do |controller|
        if controller =~ /_controller.rb\z/
          controller_name = controller.camelize.gsub(".rb","")
          permissions = (eval("Admin::#{controller_name}.new.methods") - Object.methods - ApplicationController.new.methods).sort
          permissions.reject! { |method| method =~ /_one_time_conditions/ || method =~ /_callback_before/ }
          permissions.each  {|action|
            model_name = controller_name.gsub("Controller","").camelize.singularize
            # Only controller actions to existing models are taken into account
            models.each do |model|
              if model_name == model
                begin
                  Permission.create!(:model_name => model_name, :action_name => action)
                  puts "#{action} and #{model_name}"
                rescue Exception => e
                  puts e.message + ": #{model_name} - #{action}"
                end
              end  
            end  
          }    
        end
    end
  end
end
