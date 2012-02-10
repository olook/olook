class PermissionMapBuilder

  ENABLED = "1"
  DISABLED = "0"

  attr_accessor :permissions

  def initialize(permissions=[])
    @permissions = permissions
  end

  def map(new_permissions)
    new_permissions.values.each do |permission|
      id = permission.values_at("id").first
      status = permission.values_at("enabled").first
      status == ENABLED ? add_permission(Permission.find(id)) : remove_permission(Permission.find(id))
    end
    @permissions
  end

  private

  def add_permission(permission)
    unless @permissions.include?(permission)
      @permissions << permission 
    end
  end

  def remove_permission(permission)
    unless !@permissions.include?(permission)
      self.permissions.delete(permission)
    end
  end   

end