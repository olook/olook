# -*- encoding : utf-8 -*-
casual       = {:name => "Casual", :banner => "casual" }
traditional  = {:name => "Tradicional", :banner => "traditional" }
elegant      = {:name => "Elegante", :banner => "elegant" }
feminine     = {:name => "Feminina", :banner => "feminine" }
sexy         = {:name => "Sexy", :banner => "sexy" }
contemporary = {:name => "Contemporanea", :banner => "contemporary" }
trendy       = {:name => "Trendy", :banner => "trendy" }

survey_data = []

survey_data[0] = {
  :question_title => "1. Com qual dessas celebridades brasileiras você se identifica mais?",
  :answers => ["Debora Secco", "Grazi Mazzafera", "Carolina Dieckmann"],
  :weights => [{"Debora Secco" => {"5" => feminine, "10" => sexy, "3" => trendy}},
               {"Grazi Mazzafera" => {"5" => elegant, "10" => feminine, "3" => trendy}},
               {"Carolina Dieckmann" => {"3" => casual, "5" => feminine, "3" => trendy}}]
}

survey_data[1] = {
  :question_title => "2. Com qual dessas celebridades internacionais você se identifica mais?",
  :answers => ["Natalie Portman", "Gwyneth Paltrow", "Angelina Jolie"],
  :weights => [{"Natalie Portman" => {"3" => elegant, "10" => feminine, "5" => contemporary}},
               {"Gwyneth Paltrow" => {"3" => traditional, "10" => elegant, "5" => contemporary}},
               {"Angelina Jolie" => {"3" => casual, "5" => elegant, "10" => sexy}}]
}

survey_data[2] = {
  :question_title => "3. De qual desses ícones de estilo você gostaria de herdar o guarda-roupa?",
  :answers => ["Sarah Jessica Parker", "Carla Bruni", "Kate Moss"],
  :weights => [{"Sarah Jessica Parker" => {"5" => feminine, "3" => contemporary, "10" => trendy}},
               {"Carla Bruni" => {"5" => traditional, "10" => elegant, "3" => feminine}},
               {"Kate Moss" => {"3" => elegant, "10" => sexy, "5" => contemporary}}]
}

survey_data[3] = {
  :question_title => "4. Qual dessas peças não pode faltar no seu dia a dia?",
  :answers => ["Jeans", "Vestido", "Blazer"],
  :weights => [{"Jeans" => {"10" => casual, "3" => sexy, "5" => trendy}},
               {"Vestido" => {"3" => elegant, "10" => feminine, "5" => sexy}},
               {"Blazer" => {"5" => traditional, "10" => elegant, "5" => contemporary}}]
}

survey_data[4] = {
  :question_title => "5. Qual desses estilos de cabelo mais te agradam?",
  :answers => ["Chanel Básico", "Curtíssimo repicado", "Longo esvoaçante"],
  :weights => [{"Chanel Básico" => {"5" => traditional, "10" => elegant, "3" => feminine}},
               {"Curtíssimo repicado" => {"10" => contemporary, "3" => trendy, "5" => casual}},
               {"Longo esvoaçante" => {"5" => feminine, "10" => sexy, "3" => trendy}}]
}

survey_data[5] = {
  :question_title => "6. Se pudesse voltar no tempo, que época da moda você escolheria?",
  :answers => ["Anos 1950", "Anos 1960", "Anos 1970"],
  :weights => [{"Anos 1950" => {"3" => traditional, "10" => elegant, "5" => feminine}},
               {"Anos 1960" => {"10" => contemporary, "3" => trendy, "5" => casual}},
               {"Anos 1970" => {"3" => casual, "10" => sexy, "10" => trendy}}]
}

survey_data[6] = {
  :question_title => "7. Qual desses roteiros de viagem mais te agrada?",
  :answers => ["Europa Cultural", "China e Japão", "Ilhas Gregas"],
  :weights => [{"Europa Cultural" => {"10" => traditional, "5" => elegant, "3" => feminine}},
               {"China e Japão" => {"5" => casual, "10" => contemporary, "3" => trendy}},
               {"Ilhas Gregas" => {"3" => casual, "10" => sexy, "10" => trendy}}]
}

survey_data[7] = {
  :question_title => "8. Se você fosse escolher um estilo de dança para aprender, qual seria?",
  :answers => ["Dança de salão", "Tango", "Samba" ],
  :weights => [{"Dança de salão" => {"10" => traditional, "3" => elegant, "5" => feminine}},
               {"Tango" => {"10" => sexy, "5" => contemporary, "3" => trendy}},
               {"Samba" => {"10" => casual, "3" => feminine, "5" => sexy}}]
}

survey_data[8] = {
  :question_title => "9. Qual dessas revistas femininas você tem o hábito de ler?",
  :answers => ["Elle", "Marie Claire", "Claudia" ],
  :weights => [{"Elle" => {"5" => feminine, "3" => sexy, "10" => trendy}},
               {"Marie Claire" => {"3" => traditional, "5" => elegant, "10" => contemporary}},
               {"Claudia" => {"5" => casual, "10" => traditional, "3" => feminine}}]
}

survey_data[9] = {
  :question_title => "10. Com qual desses trajes você costuma dormir?",
  :answers => ["Camisola de seda", "Pijama de algodão", "Camisola de rendinha" ],
  :weights => [{"Camisola de seda" => {"3" => traditional, "5" => elegant, "10" => sexy}},
               {"Pijama de algodão" => {"10" => casual, "3" => traditional, "5" => contemporary}},
               {"Camisola de rendinha" => {"5" => casual, "10" => feminine, "3" => sexy}}]
}
survey_data[10] = {
  :question_title => "11. Qual desses modelos de óculos escuros mais combina com você?",
  :answers => ["Clássicos em acetato", "O bom e velho modelo aviador", "Tipo gatinho" ],
  :weights => [{"Clássicos em acetato" => {"10" => traditional, "5" => elegant, "3" => contemporary}},
               {"O bom e velho modelo aviador" => {"10" => casual, "5" => sexy, "3" => trendy}},
               {"Tipo gatinho" => {"3" => casual, "10" => contemporary, "5" => trendy}}]
}

survey_data[11] = {
  :question_title => "12. Escolha o look que mais te agrada para o dia a dia.",
  :answers => ["Tudo com jeans", "Tudo com peças de alfaiataria", "Um vestidão de malha resolve tudo" ],
  :weights => [{"Tudo com jeans" => {"5" => casual, "10" => contemporary, "3" => trendy}},
               {"Tudo com peças de alfaiataria" => {"10" => traditional, "5" => elegant, "3" => contemporary}},
               {"Um vestidão de malha resolve tudo" => {"10" => casual, "3" => sexy, "5" => contemporary}}]
}

survey_data[12] = {
  :question_title => "13. Escolha o look que mais te agrada para noite.",
  :answers => ["Pretinho basico + Sandália", "Jeans skinny + Saltão", "Vestido longo + Sandália rasteira" ],
  :weights => [{"Pretinho basico + Sandália" => {"10" => traditional, "5" => elegant, "3" => sexy}},
               {"Jeans skinny + Saltão" => {"10" => casual, "5" => sexy, "3" => trendy}},
               {"Vestido longo + Sandália rasteira" => {"10" => casual, "5" => contemporary, "3" => trendy}}]
}

survey_data[13] = {
  :question_title => "14. Quais acessórios você usaria para trabalhar?",
  :answers => ["Sapatilha + Bolsa prática", "Tipo chanel + Bolsa clássica", "Scarpin salto quadrado + Bolsa hit da estação" ],
  :weights => [{"Sapatilha + Bolsa prática" => {"10" => casual, "3" => elegant, "5" => feminine}},
               {"Tipo chanel + Bolsa clássica" => {"10" => traditional, "5" => elegant, "3" => feminine}},
               {"Scarpin salto quadrado + Bolsa hit da estação" => {"3" => casual, "10" => contemporary, "5" => trendy}}]
}

survey_data[14] = {
  :question_title => "15. Quais acessórios você usaria para um domigo à tarde?",
  :answers => ["Gladiadora + Bolsa molhinha", "Sapatilha + Maxibolsa", "Sandália anabela + Bolsa box alça longa" ],
  :weights => [{"Gladiadora + Bolsa molhinha" => {"3" => casual, "5" => contemporary, "10" => trendy}},
               {"Sapatilha + Maxibolsa" => {"3" => traditional, "10" => elegant, "5" => feminine}},
               {"Sandália anabela + Bolsa box alça longa" => {"3" => elegant, "10" => feminine, "5" => sexy}}]
}

survey_data[15] = {
  :question_title => "16. Quais acessórios você usaria em uma festa?",
  :answers => ["Sandália salto fino + Clutch oncinha", "Ankle boot salto + Clutch pedrarias", "Scarpin verniz + Clutch neutra" ],
  :weights => [{"Sandália salto fino + Clutch oncinha" => {"3" => elegant, "5" => feminine, "10" => sexy}},
               {"Ankle boot salto + Clutch pedrarias" => {"3" => sexy, "5" => contemporary, "10" => trendy}},
               {"Scarpin verniz + Clutch neutra" => {"5" => casual, "10" => traditional, "3" => contemporary}}]
}

survey_data[16] = {
  :question_title => "17. Quais acessórios você escolheria para um pretinho básico?",
  :answers => ["Sapatilha + Bolsa alçinha + Brinco básico", "Scarpin + Bolsa estruturada + Colares importantes", "Ankle boot + Clutch + Brincão" ],
  :weights => [{"Sapatilha + Bolsa alçinha + Brinco básico" => {"10" => casual, "5" => traditional, "3" => feminine}},
               {"Scarpin + Bolsa estruturada + Colares importantes" => {"3" => traditional, "10" => elegant, "5" => feminine}},
               {"Ankle boot + Clutch + Brincão" => {"5" => sexy, "5" => contemporary, "10" => trendy}}]
}

survey_data[17] = {
  :question_title => "18. Maquiagem para você é...",
  :answers => ["Indispensável. Uso tudo todos os dias", "Importante. Rimel e Batom resolvem a questão", "Eventual. Só uso em ocasiões especiais" ],
  :weights => [{"Indispensável. Uso tudo todos os dias" => {"5" => elegant, "10" => feminine, "3" => trendy}},
               {"Importante. Rimel e Batom resolvem a questão" => {"3" => traditional, "5" => feminine, "10" => contemporary}},
               {"Eventual. Só uso em ocasiões especiais" => {"10" => casual, "5" => traditional, "3" => feminine}}]
}

survey_data[18] = {
  :question_title => "19. Como você costuma combinar as cores?",
  :answers => ["Neutros e mais neutros", "Neutros com toque vibrante", "Tudo pode combinar com tudo" ],
  :weights => [{"Neutros e mais neutros" => {"5" => casual, "10" => traditional, "3" => contemporary}},
               {"Neutros com toque vibrante" => {"5" => elegant, "10" => feminine, "3" => sexy}},
               {"Tudo pode combinar com tudo" => {"5" => feminine, "3" => sexy, "10" => trendy}}]
}

survey_data[19] = {
  :question_title => "20. Como você gosta do caimento das suas roupas?",
  :answers => ["Justas, valorizando minha silhueta", "Caimento certo, linhas retas", "Estruturadas, sem revelar muito as formas" ],
  :weights => [{"Justas, valorizando minha silhueta" => {"5" => feminine, "10" => sexy, "3" => trendy}},
               {"Caimento certo, linhas retas" => {"10" => traditional, "5" => elegant, "3" => trendy}},
               {"Estruturadas, sem revelar muito as formas" => {"3" => casual, "5" => traditional, "10" => contemporary}}]
}

survey_data[20] = {
  :question_title => "21. Que tipo de acessório mais te agrada?",
  :answers => ["Clássicos e atemporais", "Peças diferenciadas com toque vintage ou étnico", "Peças grandes e com brilho" ],
  :weights => [{"Clássicos e atemporais" => {"5" => traditional, "10" => elegant, "3" => contemporary}},
               {"Peças diferenciadas com toque vintage ou étnico" => {"5" => casual, "10" => trendy}},
               {"Peças grandes e com brilho" => {"3" => elegant, "5" => feminine, "10" => sexy}}]
}

survey_data[21] = {
  :question_title => "22. Que tipo de salto você prefere?",
  :answers => ["Alto", "Médio", "Baixo", "Rasteirinha"],
  :weights => []
}

survey_data[22] = {
  :question_title => "23. Quais palavras você mais gosta? (Escolha 3 opções)",
  :answers => ["Esportiva", "Frágil", "Atraente", "Romântica", "Prática", "Chic", "Criativa", "Sofisticada", "Glamourosa", "Moderna", "Conservadora", "Espirituosa"],
  :weights => [
                {"Esportiva"    => {"10" => casual, "5" => contemporary, "3" => trendy}},
                {"Frágil"       => {"3" => casual, "5" => feminine, "5" => trendy}},
                {"Atraente"     => {"5" => elegant, "10" => sexy, "3" => contemporary}},
                {"Romântica"    => {"5" => traditional, "3" => elegant, "10" => feminine}},
                {"Prática"      => {"10" => casual, "3" => traditional, "5" => contemporary}},
                {"Chic"         => {"5" => traditional, "10" => elegant, "3" => contemporary}},
                {"Criativa"     => {"3" => sexy, "5" => contemporary, "10" => trendy}},
                {"Sofisticada"  => {"3" => traditional, "10" => elegant, "5" => sexy}},
                {"Glamourosa"   => {"3" => feminine, "10" => sexy, "5" => trendy}},
                {"Moderna"      => {"3" => sexy, "10" => contemporary, "5" => trendy}},
                {"Conservadora" => {"10" => traditional, "5" => elegant, "3" => feminine}},
                {"Espirituosa"  => {"10" => casual, "5" => sexy, "3" => trendy}}
              ]
}

survey_data[23] = {
  :question_title => "Neutras",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[24] = {
  :question_title => "Metalizadas",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[25] = {
  :question_title => "Tons Pastel",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[26] = {
  :question_title => "Vivas",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[27] = {
  :question_title => "Qual o tamanho do seu sapato?",
  :answers => (33..41).to_a,
  :weights => []
}

survey_data[28] = {
  :question_title => "Qual tamanho de vestido você usa?",
  :answers => %w(PP P M G GG),
  :weights => []
}

SURVEY_DATA = survey_data

