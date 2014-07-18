class Ability
  include CanCan::Ability
  def initialize(admin)
    if admin.has_role? :superadministrator
      can :manage, :all
    else
      admin.role.permissions.each do |permission|
        begin
          if controllers_without_model.include?(permission.model_name)
            can permission.action_name.to_sym, permission.model_name.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
          else
            can permission.action_name.to_sym, permission.model_name.constantize
          end
        rescue NameError => e
          Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
          next
        end
      end
    end
  end

  def controllers_without_model
    ["VisibilityBatch", "NewestReport", "BilletReport", "HtmlGenerator", "Integration", "B2bOrder"]
  end
end
