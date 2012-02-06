class Role < ActiveRecord::Base

  has_many :admins
  has_and_belongs_to_many :permissions
  #accepts_nested_attributes_for :permissions, :reject_if => :all_blank
  
  validates :name, :uniqueness => true

  def permissions_attributes=(new_permissions_attributes)
    self.permissions = PermissionMapBuilder.new(new_permissions_attributes, self.permissions).permissions
  end

  def has_permission?(permission_id)
    self.permissions.include?(Permission.find(permission_id)) ? true : false
  end


end
