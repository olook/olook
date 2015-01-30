class MigrateImageToBannerImageOnHighlight < ActiveRecord::Migration
  def up
    Highlight.all.each { |h| h.remote_banner_image_url = "http:#{h.image_for_position}"; h.save }
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
