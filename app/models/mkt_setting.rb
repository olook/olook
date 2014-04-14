class MktSetting < RailsSettings::CachedSettings
  self.table_name = 'mkt_settings'

  attr_accessible :var
end
