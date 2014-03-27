class Ability
  include CanCan::Ability
  def initialize(admin)
    if admin.has_role? :superadministrator
      can :manage, :all
    else
      can :manage, :visibility_batch
      admin.role.permissions.each do |permission|
        begin
          if controllers_without_model.include?(permission.model_name)
            can permission.action_name.to_sym, permission.model_name.gsub!(/(.)([A-Z])/,'\1_\2').downcase
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
    ["VisibilityBatch"]
  end
end
