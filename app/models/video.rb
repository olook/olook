class Video < ActiveRecord::Base
	attr_accessible :title, :url

  validates :title, :presence => true
  validates :url, :presence => true
  validates :video_relation_id, :presence => true
  validates :video_relation_type, :presence => true

  belongs_to :video_relation, :polymorphic => true
end
