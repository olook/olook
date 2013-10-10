class DropLandingPages < ActiveRecord::Migration
  def up
    drop_table :landing_pages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
