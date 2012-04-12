# -*- encoding : utf-8 -*-
casual       = {:name => "Casual", :banner => "casual" }
traditional  = {:name => "Tradicional", :banner => "traditional" }
elegant      = {:name => "Elegante", :banner => "elegant" }
feminine     = {:name => "Feminina", :banner => "feminine" }
sexy         = {:name => "Sexy", :banner => "sexy" }
fashionista  = {:name => "Fashionista", :banner => "contemporary" }
contemporary = {:name => "Contemporanea", :banner => "contemporary" }
trendy       = {:name => "Trendy", :banner => "trendy" }
basic        = {:name => "Básica", :banner => "casual" }


survey_data = []

survey_data[0] = {
  :question_title => "1. Qual desses sapatos combina mais com o estilo da sua presenteada?",
  :answers => ["Sapato 1", "Sapato 2", "Sapato 3"],
  :weights => [{"Sapato 1" => {"2" => fashionista, "1" => sexy}},
               {"Sapato 2" => {"2" => basic, "1" => feminine}},
               {"Sapato 3" => {"2" => traditional, "1" => elegant}}]
}

survey_data[1] = {
  :question_title => "2. Qual dessas bolsas combina mais com o estilo da sua presenteada?",
  :answers => ["Bolsa 1" ,"Bolsa 2" , "Bolsa 3"],
  :weights => [{"Bolsa 1" => {"2" => elegant, "1" => traditional}},
               {"Bolsa 2" => {"2" => sexy, "1" => trendy}},
               {"Bolsa 3" => {"2" => feminine, "1" => basic}}]
}

survey_data[2] = {
  :question_title => "3. Que tipo de maquiagem tem mais a cara da sua presenteada?",
  :answers => ["Maquiagem 1" ,"Maquiagem 2" , "Maquiagem 3"],
  :weights => [{"Maquiagem 1" => {"1" => elegant, "2" => sexy}},
               {"Maquiagem 2" => {"1" => fashionista, "2" => trendy}},
               {"Maquiagem 3" => {"1" => traditional, "2" => basic}}]
}

survey_data[3] = {
  :question_title => "4. Entre essas três peças, qual combina mais com a sua presenteada?",
  :answers => ["Peça 1" ,"Peça 2" , "Peça 3"],
  :weights => [{"Peça 1" => {"2" => elegant, "1" => traditional}},
               {"Peça 2" => {"2" => basic, "1" => feminine}},
               {"Peça 3" => {"2" => trendy, "1" => fashionista}}]
}

survey_data[4] = {
  :question_title => "5. Qual desses saltos sua presenteada usaria?",
  :answers => ["Salto 1" ,"Salto 2" , "Salto 3"],
  :weights => [{"Salto 1" => {"2" => fashionista, "1" => trendy}},
               {"Salto 2" => {"2" => elegant, "1" => sexy}},
               {"Salto 3" => {"2" => feminine, "1" => sexy}}]
}
survey_data[5] = {
  :question_title => "Qual dessas sapatilhas tem mais a cara da sua presenteada?",
  :answers => ["Sapatilha 1" ,"Sapatilha 2" , "Sapatilha 3"],
  :weights => [{"Sapatilha 1" => {"1" => basic, "2" => traditional}},
               {"Sapatilha 2" => {"2" => fashionista, "1" => trendy}},
               {"Sapatilha 3" => {"1" => feminine, "2" => trendy}}]
}

survey_data[6] = {
  :question_title => "Qual dessas peças de roupa você vê mais a sua presenteada usando?",
  :answers => ["Peça de roupa 1" ,"Peça de roupa 2" , "Peça de roupa 3"],
  :weights => [{"Peça de roupa 1" => {"2" => basic, "1" => traditional}},
               {"Peça de roupa 2" => {"1" => basic, "1" => traditional}},
               {"Peça de roupa 3" => {"1" => feminine, "2" => sexy}}]
}

GIFT_SURVEY_DATA = survey_data
