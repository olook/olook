# -*- encoding: utf-8 -*-
namespace :moments do

	desc "generate basic moments"
	task :generate, [:file] => :environment do |task, args|   
		
		Moment.new( { :name => "Todas", 
									:article => "",
									:slug => "todas",
									:position => 1 } ).save!

		Moment.new( { :name => "Trabalho", 
									:article => "Para o", 
									:slug => "trabalho",
									:position => 2 } ).save!

		Moment.new( { :name => "Dia-a-dia", 
									:article => "Para o", 
									:slug => "dia-a-dia",
									:position => 3 } ).save!

		Moment.new( { :name => "Noite", 
									:article => "Para a", 
									:slug => "noite",
									:position => 4 } ).save!

		Moment.new( { :name => "Passeio", 
									:article => "Para um", 
									:slug => "passeio",
									:position => 5 } ).save!
		
	end

end