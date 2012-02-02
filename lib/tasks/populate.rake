# -*- encoding : utf-8 -*-
namespace :db do
  task :populate => :environment  do
    create_contact_subjects
  end

  task :update_friend_questions => :environment  do
    update_friend_questions
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

def update_friend_questions
  friend_questions = ["Com qual dessas celebridades brasileiras __USER_NAME__ se identifica mais?",
   "Com qual dessas celebridades internacionais __USER_NAME__ se identifica mais?",
   "De qual desses ícones de estilo __USER_NAME__ gostaria de herdar o guarda-roupa?",
   "Qual dessas peças não pode faltar no dia a dia de __USER_NAME__?",
   "Qual desses estilos de cabelo mais agradaria __USER_NAME__?",
   "Se pudesse voltar no tempo, que época da moda __USER_NAME__ escolheria?",
   "Qual desses roteiros de viagem mais agradaria __USER_NAME__?",
   "Se __USER_NAME__ fosse escolher um estilo de dança para aprender, qual seria?",
   "Qual dessas revistas femininas __USER_NAME__ tem o hábito de ler?",
   "Com qual desses trajes __USER_NAME__ costuma dormir?",
   "Qual desses modelos de óculos escuros mais combina com __USER_NAME__?",
   "Escolha o look que mais agradaria __USER_NAME__ para o dia a dia.",
   "Escolha o look que mais agradaria __USER_NAME__ para noite.",
   "Quais acessórios __USER_NAME__ usaria para trabalhar?",
   "Quais acessórios __USER_NAME__ usaria para um domingo à tarde?",
   "Quais acessórios __USER_NAME__ usaria em uma festa?",
   "Quais acessórios __USER_NAME__ escolheria para um pretinho básico?",
   "Maquiagem para você __USER_NAME__ é...",
   "Como __USER_NAME__ costuma combinar as cores?",
   "Como __USER_NAME__ gosta do caimento das suas roupas?"]
   Question.all.each_with_index do |question, index|
     question.update_attributes(:friend_title => friend_questions[index])
   end
end
