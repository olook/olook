class FullLook::LookProfileCalculator
  CLOTH_FACTOR = 3
  SHOE_FACTOR = 2
  ACCESSORY_FACTOR = 1
  BAG_FACTOR = 1

  def self.calculate products
    profiles = products.map{|p| p.profiles.map(&:name)}.flatten
    profiles
  end
end
