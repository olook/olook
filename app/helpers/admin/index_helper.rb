# -*- encoding : utf-8 -*-
module Admin::IndexHelper

  def access_link(object)
    link_to(object.humanize.to_s, eval("admin_#{object.split.join.tableize}_path")) if can?(:index, object.singularize.split.join.constantize)
  end

  def show_link(object, content = "Show")
    link_to(content, eval("admin_#{object.class.name.downcase}_path(#{object.class.name.downcase})")) if can?(:read, object)
  end

  def edit_link(object, content = "Edit")
    link_to(content, "edit_admin_#{object.class.name.downcase}_path(#{object.class.name.downcase})".to_sym) if can?(:update, object)

  end

  def destroy_link(object, content = "Destroy")
    link_to(content, eval("admin_#{object.class.name.downcase}_path(#{object.class.name.downcase})"), :method => :delete, :confirm => "Are you sure?") if can?(:destroy, object)
  end

  def create_link(object, content = "New")
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end

end
