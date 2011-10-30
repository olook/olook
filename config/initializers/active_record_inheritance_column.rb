# Overiding the default column used for single table inheritance so we can use
# the type column for other more useful things
ActiveRecord::Base.inheritance_column = "_type"
