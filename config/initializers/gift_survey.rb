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
  :question_title => "1. Com qual dessas celebridades brasileiras sua presenteada se identifica mais?",
  :answers => ["Debora Secco", "Grazi Mazzafera", "Priscila Fantin"],
  :weights => [{"Debora Secco" => {"10" => feminine, "20" => sexy, "20" => trendy, "10" => elegant, "10" => casual, "10" => contemporary}},
               {"Grazi Mazzafera" => {"30" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => casual}},
               {"Priscila Fantin" => {"30" => feminine, "10" => trendy, "30" => casual}}]
}

survey_data[1] = {
  :question_title => "2. Com qual dessas celebridades internacionais sua presenteada se identifica mais?",
  :answers => ["Blake Lively", "Kate Winslet", "Angelina Jolie"],
  :weights => [{"Blake Lively" => {"20" => sexy, "10" => trendy, "10" => elegant, "10" => contemporary}},
               {"Kate Winslet" => {"20" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => traditional}},
               {"Angelina Jolie" => {"40" => sexy, "20" => elegant}}]
}

survey_data[2] = {
  :question_title => "3. De qual desses ícones de estilo sua presenteada gostaria de herdar o guarda-roupa?",
  :answers => ["Sarah Jessica Parker", "Carla Bruni", "Kate Moss"],
  :weights => [{"Sarah Jessica Parker" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "20" => traditional, "20" => contemporary}},
               {"Carla Bruni" => {"10" => trendy, "30" => elegant, "10" => traditional, "10" => contemporary}},
               {"Kate Moss" => {"20" => sexy, "10" => trendy, "20" => elegant, "10" => contemporary}}]
}

survey_data[3] = {
  :question_title => "4. Qual dessas peças não pode faltar no dia a dia de sua presenteada?",
  :answers => ["Jeans", "Vestido", "Blazer"],
  :weights => [{"Jeans" => {"10" => trendy, "40" => casual}},
               {"Vestido" => {"10" => feminine, "10" => sexy, "10" => trendy, "10" => elegant, "10" => casual, "20" => traditional}},
               {"Blazer" => {"10" => trendy, "10" => elegant, "40" => traditional}}]
}

survey_data[4] = {
  :question_title => "22. Que tipo de salto sua presenteada prefere?",
  :answers => ["Alto", "Médio", "Baixo", "Rasteirinha"],
  :weights => []
}

survey_data[5] = {
  :question_title => "Qual o tamanho do sapato de sua presenteada?",
  :answers => (34..40).to_a,
  :weights => []
}

GIFT_SURVEY_DATA = survey_data
