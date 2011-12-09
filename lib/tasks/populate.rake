# -*- encoding : utf-8 -*-
namespace :db do
  task :populate => :environment  do
    create_contact_subjects 
  end
end

def create_contact_subjects
  ContactInformation.create!(:title => "Sugestão", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Reclamação", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Pedido de dicas de moda", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Dúvida", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Imprensa", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Parcerias blogueiras", :email => "falecom@olook.com.br")
  ContactInformation.create!(:title => "Parcerias empresas", :email => "falecom@olook.com.br")
end
