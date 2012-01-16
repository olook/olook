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
  :answers => ["Debora Secco", "Grazi Mazzafera", "Priscila Fantin"],
  :weights => [{"Debora Secco" => {"10" => feminine, "20" => sexy, "20" => trendy, "10" => elegant, "10" => casual, "10" => contemporary}},
               {"Grazi Mazzafera" => {"30" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => casual}},
               {"Priscila Fantin" => {"30" => feminine, "10" => trendy, "30" => casual}}]
}

survey_data[1] = {
  :question_title => "2. Com qual dessas celebridades internacionais você se identifica mais?",
  :answers => ["Blake Lively", "Kate Winslet", "Angelina Jolie"],
  :weights => [{"Blake Lively" => {"20" => sexy, "10" => trendy, "10" => elegant, "10" => contemporary}},
               {"Kate Winslet" => {"20" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => traditional}},
               {"Angelina Jolie" => {"40" => sexy, "20" => elegant}}]
}

survey_data[2] = {
  :question_title => "3. De qual desses ícones de estilo você gostaria de herdar o guarda-roupa?",
  :answers => ["Sarah Jessica Parker", "Carla Bruni", "Kate Moss"],
  :weights => [{"Sarah Jessica Parker" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => traditional, "20" => contemporary}},
               {"Carla Bruni" => {"10" => trendy, "30" => elegant, "10" => traditional, "10" => contemporary}},
               {"Kate Moss" => {"20" => sexy, "10" => trendy, "20" => elegant, "10" => contemporary}}]
}

survey_data[3] = {
  :question_title => "4. Qual dessas peças não pode faltar no seu dia a dia?",
  :answers => ["Jeans", "Vestido", "Blazer"],
  :weights => [{"Jeans" => {"10" => trendy, "40" => casual}},
               {"Vestido" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => casual, "20" => traditional}},
               {"Blazer" => {"10" => trendy, "10" => elegant, "40" => traditional}}]
}

survey_data[4] = {
  :question_title => "5. Qual desses estilos de cabelo mais te agradam?",
  :answers => ["Chanel Básico", "Curtíssimo repicado", "Longo esvoaçante"],
  :weights => [{"Chanel Básico" => {"10" => trendy, "10" => elegant, "30" => traditional}},
               {"Curtíssimo repicado" => {"10" => sexy, "20" => trendy, "10" => elegant, "30" => contemporary}},
               {"Longo esvoaçante" => {"20" => feminine, "20" => sexy, "10" => trendy, "10" => elegant, "10" => casual, "10" => contemporary}}]
}

survey_data[5] = {
  :question_title => "6. Se pudesse voltar no tempo, que época da moda você escolheria?",
  :answers => ["Anos 1950", "Anos 1960", "Anos 1970"],
  :weights => [{"Anos 1950" => {"30" => feminine, "10" => trendy, "10" => elegant, "10" => traditional, "20" => contemporary}},
               {"Anos 1960" => {"10" => feminine, "10" => trendy, "10" => elegant, "10" => casual, "10" => traditional, "20" => contemporary}},
               {"Anos 1970" => {"20" => trendy, "10" => elegant, "10" => casual, "30" => contemporary}}]
}

survey_data[6] = {
  :question_title => "7. Qual desses roteiros de viagem mais te agrada?",
  :answers => ["Europa Cultural", "Nova Iorque", "Ilhas Gregas"],
  :weights => [{"Europa Cultural" => {"10" => feminine, "30" => elegant, "20" => traditional}},
               {"Nova Iorque" => {"10" => sexy, "10" => trendy, "20" => elegant, "30" => contemporary}},
               {"Ilhas Gregas" => {"30" => feminine, "20" => elegant, "10" => casual, "10" => traditional}}]
}

survey_data[7] = {
  :question_title => "8. Se você fosse escolher um estilo de dança para aprender, qual seria?",
  :answers => ["Dança de salão", "Tango", "Samba" ],
  :weights => [{"Dança de salão" => {"10" => feminine, "10" => sexy, "20" => trendy, "10" => elegant, "10" => traditional}},
               {"Tango" => {"30" => sexy, "10" => trendy, "10" => elegant, "10" => traditional}},
               {"Samba" => {"20" => feminine, "10" => sexy, "30" => trendy, "10" => casual, "10" => contemporary}}]
}

survey_data[8] = {
  :question_title => "9. Qual dessas revistas femininas você tem o hábito de ler?",
  :answers => ["Elle", "Marie Claire", "Claudia" ],
  :weights => [{"Elle" => {"10" => sexy, "10" => trendy, "20" => elegant, "30" => contemporary}},
               {"Marie Claire" => {"10" => sexy, "10" => trendy, "10" => elegant, "10" => traditional, "20" => contemporary}},
               {"Claudia" => {"10" => feminine, "10" => sexy, "20" => trendy, "10" => elegant, "10" => casual, "10" => traditional, "20" => contemporary}}]
}

survey_data[9] = {
  :question_title => "10. Com qual desses trajes você costuma dormir?",
  :answers => ["Camisola de seda", "Pijama de flanela", "Camisola de algodão" ],
  :weights => [{"Camisola de seda" => {"10" => feminine, "40" => sexy, "10" => elegant}},
               {"Pijama de flanela" => {"20" => feminine, "40" => casual}},
               {"Camisola de algodão" => {"40" => feminine, "20" => casual}}]
}
survey_data[10] = {
  :question_title => "11. Qual desses modelos de óculos escuros mais combina com você?",
  :answers => ["Clássicos em acetato", "O bom e velho modelo aviador", "Tipo gatinho" ],
  :weights => [{"Clássicos em acetato" => {"10" => feminine, "10" => trendy, "10" => elegant, "30" => traditional}},
               {"O bom e velho modelo aviador" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "10" => contemporary}},
               {"Tipo gatinho" => {"10" => feminine, "20" => trendy, "10" => elegant, "10" => casual, "10" => traditional, "20" => contemporary}}]
}

survey_data[11] = {
  :question_title => "12. Escolha o look que mais te agrada para o dia a dia.",
  :answers => ["Tudo com jeans", "Tudo com peças de alfaiataria", "Um vestidão de malha resolve tudo" ],
  :weights => [{"Tudo com jeans" => {"10" => feminine, "10" => trendy, "40" => casual, "10" => contemporary}},
               {"Tudo com peças de alfaiataria" => {"10" => feminine, "10" => trendy, "20" => elegant, "10" => casual, "20" => traditional}},
               {"Um vestidão de malha resolve tudo" => {"10" => feminine, "10" => trendy, "40" => casual, "10" => traditional}}]
}

survey_data[12] = {
  :question_title => "13. Escolha o look que mais te agrada para noite.",
  :answers => ["Pretinho basico + Sandália", "Jeans skinny + Saltão", "Vestido longo + Sandália rasteira" ],
  :weights => [{"Pretinho basico + Sandália" => {"10" => sexy, "10" => trendy, "20" => elegant, "10" => casual, "10" => traditional}},
               {"Jeans skinny + Saltão" => {"20" => sexy, "20" => trendy, "10" => elegant, "30" => contemporary}},
               {"Vestido longo + Sandália rasteira" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[13] = {
  :question_title => "14. Quais acessórios você usaria para trabalhar?",
  :answers => ["Sapatilha + Bolsa prática", "Tipo chanel + Bolsa clássica", "Scarpin salto quadrado + Bolsa hit da estação" ],
  :weights => [{"Sapatilha + Bolsa prática" => {"10" => feminine, "10" => elegant, "40" => casual, "10" => traditional}},
               {"Tipo chanel + Bolsa clássica" => {"20" => elegant, "30" => traditional}},
               {"Scarpin salto quadrado + Bolsa hit da estação" => {"10" => feminine, "10" => sexy, "10" => trendy, "20" => elegant, "10" => casual, "20" => traditional, "10" => contemporary}}]
}

survey_data[14] = {
  :question_title => "15. Quais acessórios você usaria para um domigo à tarde?",
  :answers => ["Gladiadora + Bolsa molinha", "Sapatilha + Maxibolsa", "Sandália anabela + Bolsa box alça longa" ],
  :weights => [{"Gladiadora + Bolsa molinha" => {"10" => feminine, "10" => trendy, "20" => casual, "10" => contemporary}},
               {"Sapatilha + Maxibolsa" => {"20" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional}},
               {"Sandália anabela + Bolsa box alça longa" => {"20" => feminine, "10" => trendy, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[15] = {
  :question_title => "16. Quais acessórios você usaria em uma festa?",
  :answers => ["Sandália salto fino + Clutch oncinha", "Ankle boot salto + Clutch pedrarias", "Scarpin verniz + Clutch neutra" ],
  :weights => [{"Sandália salto fino + Clutch oncinha" => {"30" => sexy, "20" => trendy, "10" => elegant, "10" => contemporary}},
               {"Ankle boot salto + Clutch pedrarias" => {"20" => sexy, "10" => trendy, "20" => elegant, "10" => traditional, "10" => contemporary}},
               {"Scarpin verniz + Clutch neutra" => {"10" => sexy, "10" => trendy, "30" => elegant, "20" => traditional}}]
}

survey_data[16] = {
  :question_title => "17. Quais acessórios você escolheria para um pretinho básico?",
  :answers => ["Sapatilha + Bolsa alçinha + Brinco básico", "Scarpin + Bolsa estruturada + Colares importantes", "Ankle boot + Clutch + Brincão" ],
  :weights => [{"Sapatilha + Bolsa alçinha + Brinco básico" => {"10" => feminine, "10" => sexy, "10" => trendy, "20" => elegant, "20" => casual, "10" => traditional}},
               {"Scarpin + Bolsa estruturada + Colares importantes" => {"30" => elegant, "20" => traditional}},
               {"Ankle boot + Clutch + Brincão" => {"30" => sexy, "10" => trendy, "10" => elegant, "20" => contemporary}}]
}

survey_data[17] = {
  :question_title => "18. Maquiagem para você é...",
  :answers => ["Indispensável. Uso tudo todos os dias", "Importante. Rimel e Batom resolvem a questão", "Eventual. Só uso em ocasiões especiais" ],
  :weights => [{"Indispensável. Uso tudo todos os dias" => {"20" => sexy, "10" => trendy, "10" => elegant, "10" => casual, "10" => traditional, "10" => contemporary}},
               {"Importante. Rimel e Batom resolvem a questão" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}},
               {"Eventual. Só uso em ocasiões especiais" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[18] = {
  :question_title => "19. Como você costuma combinar as cores?",
  :answers => ["Neutros e mais neutros", "Neutros com toque vibrante", "Tudo pode combinar com tudo" ],
  :weights => [{"Neutros e mais neutros" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "20" => traditional}},
               {"Neutros com toque vibrante" => {"20" => trendy, "10" => elegant, "10" => traditional, "20" => contemporary}},
               {"Tudo pode combinar com tudo" => {"10" => trendy, "70" => contemporary}}]
}

survey_data[19] = {
  :question_title => "20. Como você gosta do caimento das suas roupas?",
  :answers => ["Justas, valorizando minha silhueta", "Caimento certo, linhas retas", "Estruturadas, sem revelar muito as formas" ],
  :weights => [{"Justas, valorizando minha silhueta" => {"40" => sexy, "10" => trendy, "10" => contemporary}},
               {"Caimento certo, linhas retas" => {"10" => sexy, "10" => trendy, "20" => elegant, "30" => traditional}},
               {"Estruturadas, sem revelar muito as formas" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[20] = {
  :question_title => "21. Que tipo de acessório mais te agrada?",
  :answers => ["Clássicos e atemporais", "Peças diferenciadas com toque vintage ou étnico", "Peças grandes e com brilho" ],
  :weights => [{"Clássicos e atemporais" => {"10" => sexy, "10" => trendy, "20" => elegant, "20" => traditional}},
               {"Peças diferenciadas com toque vintage ou étnico" => {"10" => feminine, "20" => trendy, "10" => elegant, "10" => casual, "20" => contemporary}},
               {"Peças grandes e com brilho" => {"20" => sexy, "20" => trendy, "20" => elegant, "10" => traditional}}]
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
                {"Esportiva"    => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Delicada"       => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Atraente"     => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Romântica"    => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Prática"      => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Chic"         => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Criativa"     => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Sofisticada"  => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Glamourosa"   => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Moderna"      => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Conservadora" => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}},
                {"Espirituosa"  => {"5" => feminine, "10" => sexy, "3" => trendy, "5" => elegant, "5" => casual, "5" => traditional, "5" => contemporary}}
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
  :answers => (34..40).to_a,
  :weights => []
}

survey_data[28] = {
  :question_title => "Qual tamanho de vestido você usa?",
  :answers => %w(PP P M G GG),
  :weights => []
}

SURVEY_DATA = survey_data
