class Permission < ActiveRecord::Base

  has_and_belongs_to_many :roles
  validate :model_action_uniqueness

  def model_action_uniqueness
    if Permission.find_by_model_name_and_action_name(self.model_name, self.action_name)
      errors.add(:id, ": The combination model / action must be unique")
    end
  end


end
