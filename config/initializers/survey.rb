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
  :question_title => "6. Qual desses roteiros de viagem mais te agrada?",
  :answers => ["Europa Cultural", "Nova Iorque", "Ilhas Gregas"],
  :weights => [{"Europa Cultural" => {"10" => feminine, "30" => elegant, "20" => traditional}},
               {"Nova Iorque" => {"10" => sexy, "10" => trendy, "20" => elegant, "30" => contemporary}},
               {"Ilhas Gregas" => {"30" => feminine, "20" => elegant, "10" => casual, "10" => traditional}}]
}

survey_data[6] = {
  :question_title => "7. Se você fosse escolher um estilo de dança para aprender, qual seria?",
  :answers => ["Dança de salão", "Tango", "Samba" ],
  :weights => [{"Dança de salão" => {"10" => feminine, "10" => sexy, "20" => trendy, "10" => elegant, "10" => traditional}},
               {"Tango" => {"30" => sexy, "10" => trendy, "10" => elegant, "10" => traditional}},
               {"Samba" => {"20" => feminine, "10" => sexy, "30" => trendy, "10" => casual, "10" => contemporary}}]
}

survey_data[7] = {
  :question_title => "8. Com qual desses trajes você costuma dormir?",
  :answers => ["Camisola de seda", "Pijama de flanela", "Camisola de algodão" ],
  :weights => [{"Camisola de seda" => {"10" => feminine, "40" => sexy, "10" => elegant}},
               {"Pijama de flanela" => {"20" => feminine, "40" => casual}},
               {"Camisola de algodão" => {"40" => feminine, "20" => casual}}]
}

survey_data[8] = {
  :question_title => "9. Qual desses modelos de óculos escuros mais combina com você?",
  :answers => ["Clássicos em acetato", "O bom e velho modelo aviador", "Tipo gatinho" ],
  :weights => [{"Clássicos em acetato" => {"10" => feminine, "10" => trendy, "10" => elegant, "30" => traditional}},
               {"O bom e velho modelo aviador" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "10" => contemporary}},
               {"Tipo gatinho" => {"10" => feminine, "20" => trendy, "10" => elegant, "10" => casual, "10" => traditional, "20" => contemporary}}]
}

survey_data[9] = {
  :question_title => "10. Escolha o look que mais te agrada para o dia a dia.",
  :answers => ["Tudo com jeans", "Tudo com peças de alfaiataria", "Um vestidão de malha resolve tudo" ],
  :weights => [{"Tudo com jeans" => {"10" => feminine, "10" => trendy, "40" => casual, "10" => contemporary}},
               {"Tudo com peças de alfaiataria" => {"10" => feminine, "10" => trendy, "20" => elegant, "10" => casual, "20" => traditional}},
               {"Um vestidão de malha resolve tudo" => {"10" => feminine, "10" => trendy, "40" => casual, "10" => traditional}}]
}

survey_data[10] = {
  :question_title => "11. Escolha o look que mais te agrada para a noite.",
  :answers => ["Pretinho basico + Sandália", "Jeans skinny + Saltão", "Vestido longo + Sandália rasteira" ],
  :weights => [{"Pretinho basico + Sandália" => {"10" => sexy, "10" => trendy, "20" => elegant, "10" => casual, "10" => traditional}},
               {"Jeans skinny + Saltão" => {"20" => sexy, "20" => trendy, "10" => elegant, "30" => contemporary}},
               {"Vestido longo + Sandália rasteira" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[11] = {
  :question_title => "12. Quais acessórios você usaria para trabalhar?",
  :answers => ["Sapatilha + Bolsa prática", "Tipo chanel + Bolsa clássica", "Scarpin salto quadrado + Bolsa hit da estação" ],
  :weights => [{"Sapatilha + Bolsa prática" => {"10" => feminine, "10" => elegant, "40" => casual, "10" => traditional}},
               {"Tipo chanel + Bolsa clássica" => {"20" => elegant, "30" => traditional}},
               {"Scarpin salto quadrado + Bolsa hit da estação" => {"10" => feminine, "10" => sexy, "10" => trendy, "20" => elegant, "10" => casual, "20" => traditional, "10" => contemporary}}]
}

survey_data[12] = {
  :question_title => "13. Quais acessórios você escolheria para um pretinho básico?",
  :answers => ["Sapatilha + Bolsa alçinha + Brinco básico", "Scarpin + Bolsa estruturada + Colares importantes", "Ankle boot + Clutch + Brincão" ],
  :weights => [{"Sapatilha + Bolsa alçinha + Brinco básico" => {"10" => feminine, "10" => sexy, "10" => trendy, "20" => elegant, "20" => casual, "10" => traditional}},
               {"Scarpin + Bolsa estruturada + Colares importantes" => {"30" => elegant, "20" => traditional}},
               {"Ankle boot + Clutch + Brincão" => {"30" => sexy, "10" => trendy, "10" => elegant, "20" => contemporary}}]
}

survey_data[13] = {
  :question_title => "14. Como você costuma combinar as cores?",
  :answers => ["Neutros e mais neutros", "Neutros com toque vibrante", "Tudo pode combinar com tudo" ],
  :weights => [{"Neutros e mais neutros" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "20" => traditional}},
               {"Neutros com toque vibrante" => {"20" => trendy, "10" => elegant, "10" => traditional, "20" => contemporary}},
               {"Tudo pode combinar com tudo" => {"10" => trendy, "70" => contemporary}}]
}

survey_data[14] = {
  :question_title => "15. Como você gosta do caimento das suas roupas?",
  :answers => ["Justas, valorizando minha silhueta", "Caimento certo, linhas retas", "Estruturadas, sem revelar muito as formas" ],
  :weights => [{"Justas, valorizando minha silhueta" => {"40" => sexy, "10" => trendy, "10" => contemporary}},
               {"Caimento certo, linhas retas" => {"10" => sexy, "10" => trendy, "20" => elegant, "30" => traditional}},
               {"Estruturadas, sem revelar muito as formas" => {"10" => feminine, "10" => trendy, "10" => elegant, "20" => casual, "10" => traditional, "10" => contemporary}}]
}

survey_data[15] = {
  :question_title => "16. Que tipo de salto você prefere?",
  :answers => ["Alto", "Médio", "Baixo", "Rasteirinha"],
  :weights => []
}

survey_data[16] = {
  :question_title => "Neutras",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[17] = {
  :question_title => "Metalizadas",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[18] = {
  :question_title => "Tons Pastel",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[19] = {
  :question_title => "Vivas",
  :answers => (1..5).to_a,
  :weights => []
}

survey_data[20] = {
  :question_title => "Qual o tamanho do seu sapato?",
  :answers => (34..40).to_a,
  :weights => []
}

survey_data[21] = {
  :question_title => "Qual tamanho de vestido você veste?",
  :answers => %w(PP P M G GG),
  :weights => []
}

survey_data[22] = {
  :question_title => "Qual tamanho de vestido você veste?",
  :answers => %w(PP P M G GG),
  :weights => []
}

SURVEY_DATA = survey_data
