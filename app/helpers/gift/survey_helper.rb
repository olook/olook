module Gift::SurveyHelper

  def question_title_for_recipient(question_title, relation_name)
    if question_title
      if relation_name.present?
        question_title.gsub("presenteada", content_tag(:span, relation_name)).html_safe
      else
        question_title
      end
    end
  end

end