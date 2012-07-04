module OrderTimeline
class TimelineConstructor

  include OrderTimeline::Helper

  attr_accessor :timeline_builder, :event_builder

  def initialize(timeline, order)
    @timeline_builder = TimelineBuilder.new(timeline, order)
  end

  def construction_method(state)
    self.send("build_#{state}")
  end

  def build_waiting_payment
    @timeline_builder.set_start_date
    @timeline_builder.set_headline
    @timeline_builder.set_text
    @timeline_builder.set_type
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::WaitingPayment.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    TimelineTrack.create(:order_id => timeline_builder.order.id, :timeline_track => assemble_as_hash_object)
  end

	
  def build_authorized
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::Authorized.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_delivered_date = self.timeline_delivered_date(@timeline_builder.order.payment.updated_at, @timeline_builder.order.freight.delivery_time)
    event_builder = EventBuilder.new(OrderTimeline::Event.new(timeline_delivered_date, "<b>Estimativa de entrega ao cliente</b>",""),@timeline_builder.order)
    event_builder.capture_state(Snapshot::EstimatedDeliveryDate.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_track = TimelineTrack.find_by_order_id(event_builder.order.id)
    timeline_track.update_attributes(:timeline_track => assemble_as_hash_object)
  end

  def build_picking
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::Picking.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_track = TimelineTrack.find_by_order_id(event_builder.order.id)
    timeline_track.update_attributes(:timeline_track => assemble_as_hash_object)
  end

  def build_delivering
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::Delivering.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_track = TimelineTrack.find_by_order_id(event_builder.order.id)
    timeline_track.update_attributes(:timeline_track => assemble_as_hash_object)
  end

  def build_delivered
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::Delivered.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_track = TimelineTrack.find_by_order_id(event_builder.order.id)
    timeline_track.update_attributes(:timeline_track => assemble_as_hash_object)
  end

  def build_delivered
    event_builder = EventBuilder.new(OrderTimeline::Event.new("","<b>#{@timeline_builder.order.status.downcase}</b>",""), @timeline_builder.order)
    event_builder.set_start_date(@timeline_builder.order.updated_at.to_date.to_s.gsub!("-",","))
    event_builder.capture_state(Snapshot::Canceled.new, @timeline_builder.order)
    @timeline_builder.add_event(event_builder.event)
    timeline_track = TimelineTrack.find_by_order_id(event_builder.order.id)
    timeline_track.update_attributes(:timeline_track => assemble_as_hash_object)
  end

  def update
  end

  private

  def assemble_as_hash_object
    TimelineTrack.serialize_as_hash_with_js_notation(timeline_builder.timeline)
  end

end
end