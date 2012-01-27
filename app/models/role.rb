class Role < ActiveRecord::Base
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :permissions
  #accepts_nested_attributes_for :permissions, :reject_if => :all_blank


  def permissions_attributes=(attributes)
    #e_ids = attributes.delete_if {|key, value| value["enabled"] == "0"}
    map_permissions(attributes).each do |id, status|
      status == "1" ? add_permission(id) : remove_permission(id)
    end
  end

  def map_permissions(permissions)
    permissions_map = {}
    permissions.values.each do |permission|
      permissions_map[permission.values_at("id").first] = permission.values_at("enabled").first
    end
    permissions_map
  end

  def has_permission?(permission_id)
    self.permissions.include?(Permission.find(permission_id)) ? true : false
  end


  def add_permission(permission)
        self.permissions << Permission.find(permission) unless self.has_permission?(permission)
  end

  def remove_permission(permission)
      self.permissions.delete(Permission.find(permission)) unless !self.has_permission?(permission)
  end


end
