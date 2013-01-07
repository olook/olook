# -*- encoding : utf-8 -*-

#
# Force Load all rules definitions
#
rb_files = File.join( Rails.root, 'app', 'models', 'rules', '*.rb' )
Dir.glob( rb_files ).each do |file|
  require file.gsub('.rb', '')
end
