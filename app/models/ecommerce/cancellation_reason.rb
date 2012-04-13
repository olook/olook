class CancellationReason < ActiveRecord::Base
  belongs_to :order
  validates_presence_of :source
end
