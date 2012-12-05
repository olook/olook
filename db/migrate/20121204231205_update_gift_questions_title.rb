# -*- encoding : utf-8 -*-
class UpdateGiftQuestionsTitle < ActiveRecord::Migration
  def up
  	question = Question.find(68)
  	question.update_attribute(:title, '3. Que acessório combina mais com o estilo da sua presenteada?') if question
  end

  def down
  	question = Question.find(68)
  	question.update_attribute(:title, '3. Que tipo de maquiagem tem mais a cara da sua presenteada?') if question
  end
end
