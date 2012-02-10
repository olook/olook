module FriendsHelper
  def question_title_for_friend(question_title, user_name)
    question_title.gsub("__USER_NAME__", content_tag(:span, user_name)).html_safe if question_title
  end
end
