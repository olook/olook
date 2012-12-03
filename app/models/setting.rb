# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string(255)      not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < RailsSettings::Settings
  VALID_RANGE = %r(^\d+\.\.\d+$)

  def self.is_range?(value)
    value =~ VALID_RANGE
  end

  def self.convert_to_range value
    splitted_values = value.split("..")
    Range.new(splitted_values[0].to_i, splitted_values[1].to_i)
  end

end
