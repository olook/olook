class ActionParameter < ActiveRecord::Base
  belongs_to :matchable, polymorphic: true
  belongs_to :promotion_action

  def action_params=( hash )
    self[:action_params] = Hash[hash.to_a.select{ |k,v| v.present? }].to_json
  end

  def action_params
    return @action_params if @action_params
    if self[:action_params].present?
      @action_params ||= JSON.parse( self[:action_params] ) rescue { param: self[:action_params] }
    else
      @action_params ||= {}
    end
    @action_params = self.promotion_action.class.default_filters.merge(@action_params)
  end
end
