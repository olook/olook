class Permission < ActiveRecord::Base

  has_and_belongs_to_many :roles

  validates :action_name, :uniqueness => {:scope => :model_name, :message => "for given Model exists"}

end
