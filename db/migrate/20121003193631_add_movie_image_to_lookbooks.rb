class AddMovieImageToLookbooks < ActiveRecord::Migration
  def change
    add_column :lookbooks, :movie_image, :string

  end
end
