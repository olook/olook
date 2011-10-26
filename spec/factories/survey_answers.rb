# -*- encoding : utf-8 -*-
Factory.define :survey_answers, :class => SurveyAnswer do |f|
  f.answers eval("{:foo => :bar}")
end

