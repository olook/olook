class Role < ActiveRecord::Base

  has_many :admins
  has_and_belongs_to_many :permissions
  #accepts_nested_attributes_for :permissions, :reject_if => :all_blank
  
  validates :name, :uniqueness => true

  def permissions_attributes=(attributes)
    self.permissions = PermissionMapBuilder.new(attributes, self.permissions).permissions
  end

  def has_permission?(permission)
    self.permissions.include?(Permission.find(permission)) ? true : false
  end


end
