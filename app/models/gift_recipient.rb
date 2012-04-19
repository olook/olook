# -*- encoding : utf-8 -*-
class GiftRecipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :gift_recipient_relation
  has_many :occasions
  belongs_to :profile
  serialize :ranked_profile_ids, Array

  validates_associated :user, :gift_recipient_relation

  validates :name, :presence => true, :length => {:minimum => 2}
  validates :shoe_size, :numericality => {:only_integer => true, :greater_than => 0, :less_than => 50}, :allow_nil => true

  delegate :name, :to => :gift_recipient_relation, :allow_nil => true, :prefix => :relation

  def first_name
    self.name.split[0] if self.name
  end

  def belongs_to_user?(user)
    user_id == user.try(:id)
  end

  def ranked_profiles(first_profile = nil)
    all_profile_ids = ranked_profile_ids.empty? ? Profile.all.map(&:id) : ranked_profile_ids
    profile_ids = first_profile ? ([first_profile.to_i] + all_profile_ids).uniq.compact : all_profile_ids
    profile_ids.map { |id| Profile.find(id) }
  end

  def profile_scores
    scores = []
    ranked_profiles.each do |profile|
      profile_struct = Struct.new(:profile)
        scores << profile_struct.new(profile)
    end
    scores
  end
end
