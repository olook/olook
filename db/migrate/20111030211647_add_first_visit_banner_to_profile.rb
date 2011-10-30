class AddFirstVisitBannerToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :first_visit_banner, :string
  end
end
