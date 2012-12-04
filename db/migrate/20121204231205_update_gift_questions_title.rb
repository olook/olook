# -*- encoding : utf-8 -*-
class UpdateGiftQuestionsTitle < ActiveRecord::Migration
  def up
  	Question.find(68).update_attribute(:title, '3. Que acessório combina mais com o estilo da sua presenteada?')
  end

  def down
  	Question.find(68).update_attribute(:title => '3. Que tipo de maquiagem tem mais a cara da sua presenteada?')
  end
end
