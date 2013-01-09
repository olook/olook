# -*- encoding : utf-8 -*-

#
# Force Load all actions definitions
#
rb_files = File.join( Rails.root, 'app', 'models', 'promotions','actions', '*.rb' )
Dir.glob( rb_files ).each do |file|
  require file.gsub('.rb', '')
end
