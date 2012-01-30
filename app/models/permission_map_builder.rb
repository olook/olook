class PermissionMapBuilder

  ENABLED = "1"
  DISABLED = "0"

  attr_reader :permissions

  def initialize(new_permissions, permissions)
    @permissions = permissions
    map(new_permissions).each do |id, status|
      permission = Permission.find(id)
      status == ENABLED ? add_permission(permission) : remove_permission(permission)
    end
  end

  def map(permissions)
    permissions_map = {}
    permissions.values.each do |permission|
      permissions_map[permission.values_at("id").first] = permission.values_at("enabled").first
    end
    permissions_map
  end

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