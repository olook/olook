class MktSetting < RailsSettings::Settings
  self.table_name = 'mkt_settings'

  attr_accessible :var
end
