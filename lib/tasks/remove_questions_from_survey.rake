task :remove_questions_from_survey => :environment do |task, args|
  def update_question(id, old_number, new_number)
    q = Question.find(id)
    q.title = q.title.gsub(old_number.to_s, new_number.to_s)
    q.save
  end
  Question.where(:id => [47, 44, 38, 45, 35, 50]).delete_all
  update_question(36, 7, 6)
  update_question(37, 8, 7)
  update_question(39, 10, 8)
  update_question(40, 11, 9)
  update_question(41, 12, 10)
  update_question(42, 13, 11)
  update_question(43, 14, 12)
  update_question(46, 17, 13)
  update_question(48, 19, 14)
  update_question(49, 20, 15)
  update_question(51, 22, 16)
  update_question(52, 23, 17)

#+----+------------------------------------------------------------------------------+
#| id | title                                                                        |
#+----+------------------------------------------------------------------------------+
#| 30 | 1. Com qual dessas celebridades brasileiras você se identifica mais?         |
#| 31 | 2. Com qual dessas celebridades internacionais você se identifica mais?      |
#| 32 | 3. De qual desses ícones de estilo você gostaria de herdar o guarda-roupa?   |
#| 33 | 4. Qual dessas peças não pode faltar no seu dia a dia?                       |
#| 34 | 5. Qual desses estilos de cabelo mais te agradam?                            |
#| 36 | 7. Qual desses roteiros de viagem mais te agrada?                            |
#| 37 | 8. Se você fosse escolher um estilo de dança para aprender, qual seria?      |
#| 39 | 10. Com qual desses trajes você costuma dormir?                              |
#| 40 | 11. Qual desses modelos de óculos escuros mais combina com você?             |
#| 41 | 12. Escolha o look que mais te agrada para o dia a dia.                      |
#| 42 | 13. Escolha o look que mais te agrada para noite.                            |
#| 43 | 14. Quais acessórios você usaria para trabalhar?                             |
#| 46 | 17. Quais acessórios você escolheria para um pretinho básico?                |
#| 48 | 19. Como você costuma combinar as cores?                                     |
#| 49 | 20. Como você gosta do caimento das suas roupas?                             |
#| 51 | 22. Que tipo de salto você prefere?                                          |
#| 52 | 23. Escolha 3 palavras que definem você.                                     |
#+----+------------------------------------------------------------------------------+
end
