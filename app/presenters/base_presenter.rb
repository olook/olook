# -*- encoding : utf-8 -*-
class BasePresenter
  def initialize(template, objects)
    objects.each do |key, value|
      self.class.send :define_method, key do
        value
      end
    end
    @template = template
  end
  
  def h
    @template
  end
end
