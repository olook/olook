# == Schema Information
#
# Table name: moments
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  active       :boolean          default(FALSE)
#  slug         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  header_image :string(255)
#  article      :string(25)       not null
#  position     :integer          default(1)
#

require 'spec_helper'

describe Catalog::Moment do
  it { should belong_to(:moment) }
end
