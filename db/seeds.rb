# -*- encoding : utf-8 -*-
[Admin, Profile, Question, Answer, Weight].map(&:delete_all)

Admin.create(:email => "admin@olook.com", :password =>"123456")

casual       = Profile.create(:name => "Casual")
traditional  = Profile.create(:name => "Tradicional")
elegant      = Profile.create(:name => "Elegante")
female       = Profile.create(:name => "Feminina")
sexy         = Profile.create(:name => "Sexy")
contemporary = Profile.create(:name => "Contemporanea")
trendy       = Profile.create(:name => "Trendy")
survey_data = []

survey_data[0] = {
  :question_title => "Com qual destas celebridades brasileiras você se identifica?",
  :answers => ["Debora Secco", "Grazi Mazzafera", "Carolina Dieckman"],
  :weights => [{"Debora Secco" => {"5" => female, "10" => sexy, "3" => trendy}},
               {"Grazi Mazzafera" => {"5" => elegant, "10" => female, "3" => trendy}},
               {"Carolina Dieckman" => {"3" => casual, "5" => female, "3" => trendy}}]
}

survey_data[1] = {
  :question_title => "Com qual destas celebridades internacionais você se identifica?",
  :answers => ["Natalie Portman", "Gwyneth Paltrow", "Angelina Jolie"],
  :weights => [{"Natalie Portman" => {"3" => elegant, "10" => female, "5" => contemporary}},
               {"Gwyneth Paltrow" => {"3" => traditional, "10" => elegant, "5" => contemporary}},
               {"Angelina Jolie" => {"3" => casual, "5" => elegant, "10" => sexy}}]
}

survey_data[2] = {
  :question_title => "Qual desses icones de estilo voce gostaria de  herdar o guarda-roupa?",
  :answers => ["Sarah Jessica Parker", "Carla Bruni", "Kate Moss"],
  :weights => [{"Sarah Jessica Parker" => {"5" => female, "3" => contemporary, "10" => trendy}},
               {"Carla Bruni" => {"5" => traditional, "10" => elegant, "3" => female}},
               {"Kate Moss" => {"3" => elegant, "10" => sexy, "5" => contemporary}}]
}

survey_data[3] = {
  :question_title => "Qual dessas peças não pode faltar no seu dia a dia?",
  :answers => ["Jeans", "Vestido", "Blazer"],
  :weights => [{"Jeans" => {"10" => casual, "3" => sexy, "5" => trendy}},
               {"Vestido" => {"3" => elegant, "10" => female, "5" => sexy}},
               {"Blazer" => {"5" => traditional, "10" => elegant, "5" => contemporary}}]
}

survey_data[4] = {
  :question_title => "Quais desses estilo de cabelo mais te agradam?",
  :answers => ["Chanel", "Curtissimo", "Longo tipo Gisele"],
  :weights => [{"Chanel" => {"5" => traditional, "10" => elegant, "3" => female}},
               {"Curtíssimo" => {"10" => contemporary, "3" => trendy, "5" => casual}},
               {"Longo tipo Gisele" => {"5" => female, "10" => sexy, "3" => trendy}}]
}

survey_data[5] = {
  :question_title => "Se pudesse voltar no tempo que epoca da moda voce escolheria?",
  :answers => ["Anos 1950", "Anos 1960", "Anos 1970"],
  :weights => [{"Anos 1950" => {"3" => traditional, "10" => elegant, "5" => female}},
               {"Anos 1960" => {"10" => contemporary, "3" => trendy, "5" => casual}},
               {"Anos 1970" => {"3" => casual, "10" => sexy, "10" => trendy}}]
}

survey_data[6] = {
  :question_title => "Qual desses roteiros de viagem mais te agradam?",
  :answers => ["Europa Cultutal", "China e Japão", "Ilhas Gregas"],
  :weights => [{"Europa Cultutal" => {"10" => traditional, "5" => elegant, "3" => female}},
               {"China e Japão" => {"5" => casual, "10" => contemporary, "3" => trendy}},
               {"Ilhas Gregas" => {"3" => casual, "10" => sexy, "10" => trendy}}]
}

survey_data[7] = {
  :question_title => "Se voce fosse escolher um estilo de dança para aprender, qual seria?",
  :answers => ["Dança de salão", "Tango", "Forro" ],
  :weights => [{"Dança de salão" => {"10" => traditional, "3" => elegant, "5" => female}},
               {"Tango" => {"10" => sexy, "5" => contemporary, "3" => trendy}},
               {"Forro" => {"10" => casual, "3" => female, "5" => sexy}}]
}

survey_data[8] = {
  :question_title => "Qual dessas revistas femininas voce tem o habito de ler?",
  :answers => ["Elle", "Marie Claire", "Claudia" ],
  :weights => [{"Elle" => {"5" => female, "3" => sexy, "10" => trendy}},
               {"Marie Claire" => {"3" => traditional, "5" => elegant, "10" => contemporary}},
               {"Claudia" => {"5" => casual, "10" => traditional, "3" => female}}]
}

survey_data[9] = {
  :question_title => "Com qual desses trajes voce contuma dormir?",
  :answers => ["Camisola de Seda Longa", "Pijama de malha", "Baby Doll Rendinha" ],
  :weights => [{"Camisola de Seda Longa" => {"3" => traditional, "5" => elegant, "10" => sexy}},
               {"Pijama de malha" => {"10" => casual, "3" => traditional, "5" => contemporary}},
               {"Baby Doll Rendinha" => {"5" => casual, "10" => female, "3" => sexy}}]
}
survey_data[10] = {
  :question_title => "Qual desses modelos de oculos escuros mais combinam com voce?",
  :answers => ["quadrado de acetato", "ray ban aviador", "redondo com armacao clara" ],
  :weights => [{"quadrado de acetato" => {"10" => traditional, "5" => elegant, "3" => contemporary}},
               {"ray ban aviador" => {"10" => casual, "5" => sexy, "3" => trendy}},
               {"redondo com armacao clara" => {"3" => casual, "10" => contemporary, "5" => trendy}}]
}

survey_data[11] = {
  :question_title => "Escolha o look que mais te acgrada para o dia a dia.",
  :answers => ["jeans boyfriend e mocassim", "calca alfaiataria e scarpin", "vestido longo malha e rasteira" ],
  :weights => [{"jeans boyfriend e mocassim" => {"5" => casual, "10" => contemporary, "3" => trendy}},
               {"calca alfaiataria e scarpin" => {"10" => traditional, "5" => elegant, "3" => contemporary}},
               {"vestido longo malha e rasteira" => {"10" => casual, "3" => sexy, "5" => contemporary}}]
}

survey_data[12] = {
  :question_title => "Escolha o look que mais te agrada para noite",
  :answers => ["pretinho basico e sandalia salto fino", "jeans skinny e ankle", "vestido tec + gladiadora" ],
  :weights => [{"pretinho basico e sandalia salto fino" => {"10" => traditional, "5" => elegant, "3" => sexy}},
               {"jeans skinny e ankle" => {"10" => casual, "5" => sexy, "3" => trendy}},
               {"vestido tec + gladiadora" => {"10" => casual, "5" => contemporary, "3" => trendy}}]
}

survey_data[13] = {
  :question_title => "Qual desses modelos  você usaria para trabalhar?",
  :answers => ["sapatilha + bolsa alca longa", "peep toe + bolsa reta", "scarpin salto quadrado + bolsa hit da estação" ],
  :weights => [{"sapatilha + bolsa alca longa" => {"10" => casual, "3" => elegant, "5" => female}},
               {"peep toe + bolsa reta" => {"10" => traditional, "5" => elegant, "3" => female}},
               {"scarpin salto quadrado + bolsa hit da estação" => {"3" => casual, "10" => contemporary, "5" => trendy}}]
}

survey_data[14] = {
  :question_title => "Qual desses modelos voce usaria para um domigo a tarde?",
  :answers => ["gladiadora + bolsa molhinha", "sapatilha + maxibolsa", "sandalia anabela + bolsa box alça longa" ],
  :weights => [{"gladiadora + bolsa molhinha" => {"3" => casual, "5" => contemporary, "10" => trendy}},
               {"sapatilha + maxibolsa" => {"3" => traditional, "10" => elegant, "5" => female}},
               {"sandalia anabela + bolsa box alça longa" => {"3" => elegant, "10" => female, "5" => sexy}}]
}

survey_data[15] = {
  :question_title => "Qual desses modelos voce usaria em uma festa?",
  :answers => ["sandalia salto fino + clutch oncinha", "ankle boot salto + clutch pedrarias", "sandalia salto grosso+ bolsa lateral verniz" ],
  :weights => [{"sandalia salto fino + clutch oncinha" => {"3" => elegant, "5" => female, "10" => sexy}},
               {"ankle boot salto + clutch pedrarias" => {"3" => sexy, "5" => contemporary, "10" => trendy}},
               {"sandalia salto grosso+ bolsa lateral verniz" => {"5" => casual, "10" => traditional, "3" => contemporary}}]
}

survey_data[16] = {
  :question_title => "Quais desses acessórios voce escolheria para  este pretinho basico?",
  :answers => ["sapatilha/bolsa carteiro/ argola", "scarpin/bolsa dura/colares dourados", "ankle/cluch/ brinco de franja" ],
  :weights => [{"sapatilha/bolsa carteiro/ argola" => {"10" => casual, "5" => traditional, "3" => female}},
               {"scarpin/bolsa dura/colares dourados" => {"3" => traditional, "10" => elegant, "5" => female}},
               {"ankle/cluch/ brinco de franja" => {"5" => sexy, "5" => contemporary, "10" => trendy}}]
}

survey_data[17] = {
  :question_title => "Maquiagem para voce é...",
  :answers => ["Indispensavel. Uso tudo todos os dias", "Importante. Rimel e Batom resolvem a questão", "Eventual. Só uso em ocasiões especiais" ],
  :weights => [{"Indispensavel. Uso tudo todos os dias" => {"5" => elegant, "10" => female, "3" => trendy}},
               {"Importante. Rimel e Batom resolvem a questão" => {"3" => traditional, "5" => female, "10" => contemporary}},
               {"Eventual. Só uso em ocasiões especiais" => {"10" => casual, "5" => traditional, "3" => female}}]
}

survey_data[18] = {
  :question_title => "Como voce costuma combinar as cores?",
  :answers => ["neutros e mais neutros", "neutros com toque vibrante", "tudo pode combinar com tudo" ],
  :weights => [{"neutros e mais neutros" => {"5" => casual, "10" => traditional, "3" => contemporary}},
               {"neutros com toque vibrante" => {"5" => elegant, "10" => female, "3" => sexy}},
               {"tudo pode combinar com tudo" => {"5" => female, "3" => sexy, "10" => trendy}}]
}

survey_data[19] = {
  :question_title => "Como você gosta do caimento das suas roupas?",
  :answers => ["Caimento certo, linhas retas", "Justas, valorizando minha silhueta", "Estruturadas, sem revelar muito as formas" ],
  :weights => [{"Caimento certo, linhas retas" => {"10" => traditional, "5" => elegant, "3" => trendy}},
               {"Justas, valorizando minha silhueta" => {"5" => female, "10" => sexy, "3" => trendy}},
               {"Estruturadas, sem revelar muito as formas" => {"3" => casual, "5" => traditional, "10" => contemporary}}]
}

survey_data[20] = {
  :question_title => "Que tipo de acessório mais te agrada?",
  :answers => ["Clássicas e atemporais", "Peças diferenciadas toque vintage ou etnico", "Peças grandes e com brilho" ],
  :weights => [{"Clássicas e atemporais" => {"5" => traditional, "10" => elegant, "3" => contemporary}},
               {"Peças diferenciadas toque vintage ou etnico" => {"5" => casual, "10" => trendy}},
               {"Peças grandes e com brilho" => {"3" => elegant, "5" => female, "10" => sexy}}]
}

survey_data[21] = {
  :question_title => "Qual a sua nota para estas cartelas de cores?",
  :answers => ["Neutras", "Metalizadas", "Tons Pastel", "Vivas" ],
  :weights => []
}

survey_data[22] = {
  :question_title => "Qual o tamanho do seu sapatos?",
  :answers => (33..41).to_a,
  :weights => []
}

survey_data[22] = {
  :question_title => "Qual tamanho de vestido que você veste?",
  :answers => %w(PP, P, M, G, GG),
  :weights => []
}

survey_data.each do |item|
  question = Question.create(:title => item[:question_title])
  item[:answers].each do |title|
    answer = question.answers.create(:title => title)
  end
  item[:weights].each do |weight|
    weight.each do |answer_title, weight_profile|
      weight_profile.each do |weight_value, profile|
        print "."
        answer = Answer.find_by_title(answer_title)
        Weight.create(:profile => profile, :answer => answer, :weight => weight_value)
      end
    end
  end
end
