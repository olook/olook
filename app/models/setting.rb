class Setting < RailsSettings::Settings
  VALID_RANGE = %r(^\d+\.\.\d+$)

  def self.is_range?(value)
    value =~ VALID_RANGE
  end

  def self.convert_to_range value
    splitted_values = value.split("..")
    Range.new(splitted_values[0].to_i, splitted_values[1].to_i)
  end

  def self.as_list property_name

    value = self[property_name.to_sym]
    value.nil? ? [] : value.split(",")
  end

end
