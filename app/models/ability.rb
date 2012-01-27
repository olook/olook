class Ability
  include CanCan::Ability

  def initialize(admin)
    if admin.has_roles? :superadministrator
      can :manage, :all
    else
      admin.roles.each do |role|
        role.permissions.each do |permission|
          can permission.action_name.to_sym, permission.model_name.constantize
         end
       end
    end
  end

end
