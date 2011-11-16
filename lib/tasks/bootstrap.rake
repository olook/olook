namespace :db do
  desc "Bootstrap the database with demo data"
  task :boostrap => %w(db:setup) do
    20.times do
      product = Product.new :name => Faker::Lorem.words(1).first, :description => Faker::Lorem.paragraph(10), :category => (1..3).to_a.sample, :model_number => rand(36**8).to_s(36)
      if product.save!
        puts "."
      end
    end
  end
end
