class Ability
  include CanCan::Ability
  def initialize(admin)
    if admin.has_role? :superadministrator
      can :manage, :all
    else
      admin.role.permissions.each do |permission|
        can permission.action_name.to_sym, permission.model_name.constantize
      end
    end
  end
end
