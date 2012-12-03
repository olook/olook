# == Schema Information
#
# Table name: details
#
#  id                :integer          not null, primary key
#  product_id        :integer
#  translation_token :string(255)
#  description       :text
#  display_on        :integer
#  created_at        :datetime
#  updated_at        :datetime
#

# -*- encoding : utf-8 -*-
class Detail < ActiveRecord::Base
  belongs_to :product
  
  validates :product, :presence => true
  validates :translation_token, :presence => true
  validates :description, :presence => true

  has_enumeration_for :display_on, :with => DisplayDetailOn, :required => true
  
  scope :only_invisible     , where(:display_on => DisplayDetailOn::INVISIBLE)
  scope :only_specification , where(:display_on => DisplayDetailOn::SPECIFICATION)
  scope :only_how_to        , where(:display_on => DisplayDetailOn::HOW_TO)
end
