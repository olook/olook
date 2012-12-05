# -*- encoding : utf-8 -*-
class UpdateGiftQuestionsTitle < ActiveRecord::Migration
  def up
    Question.where(id: 68).update_all(title: '3. Que acessório combina mais com o estilo da sua presenteada?')
  end

  def down
    Question.where(id: 68).update_all(title: '3. Que tipo de maquiagem tem mais a cara da sua presenteada?')
  end
end
