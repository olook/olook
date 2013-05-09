module MomentsHelper
  def some_filter_selected_for? category
    basic_request = {"category_id"=> category, "id"=>1, "controller"=>"moments", "action"=>"show"}
    basic_request != params
  end
end
