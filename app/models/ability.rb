class Ability
  include CanCan::Ability
  def initialize(admin)
    if admin.has_role? :superadministrator
      can :manage, :all
    else
      admin.role.permissions.each do |permission|
        begin
          can permission.action_name.to_sym, permission.model_name.constantize
        rescue NameError => e
          Rails.logger.error("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
          next
        end
      end
    end
  end
end
