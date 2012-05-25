# -*- encoding: utf-8 -*-
namespace :moments do

	desc "generate basic moments"
	task :generate, [:file] => :environment do |task, args|   
		
		Moment.new( { :name => "Ocasiões",
									:article => "para todas as",
									:slug => "todas",
									:position => 5 } ).save!

		Moment.new( { :name => "Passeio", 
									:article => "Para um", 
									:slug => "passeio",
									:position => 4 } ).save!

		Moment.new( { :name => "Noite", 
									:article => "Para a", 
									:slug => "noite",
									:position => 3 } ).save!

		Moment.new( { :name => "Executivo", 
									:article => "Para o dia-a-dia", 
									:slug => "executivo",
									:position => 2 } ).save!

		Moment.new( { :name => "Casual", 
									:article => "Para o dia-a-dia", 
									:slug => "casual",
									:position => 1 } ).save!
		
	end

end