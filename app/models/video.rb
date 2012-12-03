# == Schema Information
#
# Table name: videos
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  url                 :string(255)
#  video_relation_id   :integer
#  video_relation_type :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Video < ActiveRecord::Base
	attr_accessible :title, :url

  validates :title, :presence => true
  validates :url, :presence => true
  validates :video_relation_id, :presence => true
  validates :video_relation_type, :presence => true

  belongs_to :video_relation, :polymorphic => true
end
