module Gift::SurveyHelper
  def question_title_for_recipient(question_title, relation_name)
    question_title.gsub("presenteada", content_tag(:span, relation_name)).html_safe if question_title
  end
end