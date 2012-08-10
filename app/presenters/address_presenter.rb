class AddressPresenter < SimpleDelegator
  def initialize(address)
    raise RuntimeError.new("The object #{address.inspect} must be a valid Address.") if address.nil? or !address.is_a?(Address)
    super(address)
  end

  def formated_to_order_metadata
    [].tap do |formated_address|
      formated_address << [street,number].compact.join(', ')
      formated_address << [complement, neighborhood, zip_code, city, state, country].delete_if{|item| item.nil? or item.blank?}
    end.flatten.delete_if{|item| item.nil? or item.blank?}.join(' - ')
  end
end