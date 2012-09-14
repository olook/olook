# -*- encoding : utf-8 -*-
class Tracking < ActiveRecord::Base
  belongs_to :user

  def clean_placement
    placement.delete(",") if placement
  end

end