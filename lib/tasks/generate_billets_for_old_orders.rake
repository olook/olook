# -*- encoding : utf-8 -*-
namespace :olook do
  task :generate_billets_for_old_orders => :environment  do
    billet_table = Billet.arel_table
    pending_billets = Billet.where(billet_table[:state].eq("started").or(billet_table[:state].eq("billet_printed")))
    billet_generator = BilletGenerator.new(pending_billets)
    puts "#{billet_generator.generate} boleto(s) gerado(s) com sucesso"
  end
end
