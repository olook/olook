desc "Create Permissions for Controllers"
namespace :olook do
  task :create_permissions => :environment do
    controllers = Dir.new("#{Rails.root}/app/controllers/admin").entries
    specific_controllers = ["newest_reports_controller.rb","billet_reports_controller.rb","visibility_batch_controller.rb","integrations_controller.rb", "b2b_orders_controller.rb"]
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
                puts "Added #{action} action for #{model_name}"
              rescue => e
                puts "Action #{action} for #{model_name} already exists"
                puts  "Action #{action} for #{model_name} already exists"
              end
            end
          end
        }
      end
    end
    specific_controllers.each do |controller|
      controller_name = controller.camelize.gsub(".rb","")
      permissions = (eval("Admin::#{controller_name}.new.methods") - Object.methods - ApplicationController.new.methods).sort
      permissions.reject! { |method| method =~ /_one_time_conditions/ || method =~ /_callback_before/ }
      permissions.each do |action|
        class_name = controller_name.gsub("Controller","").camelize.singularize
        begin
          Permission.create!(:model_name => class_name, :action_name => action)
          puts "Added #{action} action for #{class_name}"
        rescue => e
          puts "Action #{action} for #{class_name} already exists"
          puts  "Action #{action} for #{class_name} already exists"
        end
      end
    end
  end

  task :seed_admin =>:environment do
    Role.destroy_all
    Admin.destroy_all
    superadmin = Role.create(:name => "superadministrator", :description => "Manages everything in the system")
    admin = Admin.new(:email => "admin@olook.com.br", :first_name => "Olook", :last_name => "Admin",
                      :password => "olook123abc")
    admin.role = superadmin
    begin
      admin.save!
      puts "Superadmin added to the system"
    rescue Exception => e
      puts "User already exists: #{e}"
    end
  end
end
