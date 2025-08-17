# Load default seeds first
Spree::Core::Engine.load_seed
Spree::Auth::Engine.load_seed if defined?(Spree::Auth::Engine)

puts "Seeding checkout setup..."

# 1. Countries (likely already exist from default seeds)
vn = Spree::Country.find_or_create_by!(iso: "VN") do |country|
  country.iso3 = "VNM"
  country.iso_name = "VIET NAM"
  country.name = "Vietnam"
  country.numcode = 704
end
puts "Found/Created country: #{vn.name}"

au = Spree::Country.find_or_create_by!(iso: "AU") do |country|
  country.iso3 = "AUS"
  country.iso_name = "AUSTRALIA"
  country.name = "Australia"
  country.numcode = 36
end
puts "Found/Created country: #{au.name}"

# 2. State for VN
hn = Spree::State.find_or_create_by!(
  name: "Ha Noi",
  abbr: "HN",
  country: vn
)
puts "Created state: #{hn.name}"

# 3. Zones
vn_zone = Spree::Zone.find_or_create_by!(name: 'Vietnam Zone') do |zone|
  zone.description = 'Shipping zone for Vietnam'
end

# Clear existing members and add Vietnam
vn_zone.members.destroy_all
vn_zone.members.create!(zoneable: vn)

world_zone = Spree::Zone.find_or_create_by!(name: 'World Zone') do |zone|
  zone.description = 'Shipping zone for international'
end

# Clear existing members and add countries
world_zone.members.destroy_all
[au].each do |country|
  world_zone.members.create!(zoneable: country)
end

puts "Created zones: #{vn_zone.name}, #{world_zone.name}"

# 4. Shipping Category
shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "Default")
puts "Found/Created shipping category: #{shipping_category.name}"

# 5. Shipping Methods
standard_shipping = Spree::ShippingMethod.find_by(name: "Standard Shipping")

if standard_shipping
  puts "Found existing shipping method: #{standard_shipping.name}"
else
  # Create new shipping method with all required attributes
  standard_shipping = Spree::ShippingMethod.new(
    name: "Standard Shipping",
    admin_name: 'Standard Shipping',
    code: 'standard',
    available_to_all: true,
    available_to_users: true
  )

  # Set required associations before saving
  standard_shipping.zones = [vn_zone, world_zone]
  standard_shipping.shipping_categories = [shipping_category]

  # Create calculator
  standard_shipping.build_calculator(
    type: 'Spree::Calculator::Shipping::FlatRate',
    preferred_amount: 50_000, # 50k VNĐ
    preferred_currency: "VND"
  )

  standard_shipping.save!
  puts "Created shipping method: #{standard_shipping.name}"
end

# Update existing shipping method if needed
unless standard_shipping.zones.include?(vn_zone) && standard_shipping.zones.include?(world_zone)
  standard_shipping.zones = [vn_zone, world_zone]
  standard_shipping.save!
end

unless standard_shipping.shipping_categories.include?(shipping_category)
  standard_shipping.shipping_categories = [shipping_category]
  standard_shipping.save!
end
puts "Created/Updated shipping method: #{standard_shipping.name}"

# 6. Stock Location
stock_location = Spree::StockLocation.find_or_create_by!(name: "Main Warehouse") do |location|
  location.country = vn
  location.active = true
  location.default = true
  location.address1 = "Hanoi, Vietnam"
  location.city = "Hanoi"
  location.state = hn
end
puts "Created/Updated stock location: #{stock_location.name}"

# 7. Add stock for all products
product_count = 0
Spree::Product.joins(:master).find_each do |product|
  variant = product.master
  next unless variant

  stock_item = stock_location.stock_items.find_or_initialize_by(variant: variant)

  if stock_item.persisted?
    # Update existing stock
    current_stock = stock_item.count_on_hand
    if current_stock < 100
      stock_item.adjust_count_on_hand(100 - current_stock)
    end
  else
    # New stock item
    stock_item.count_on_hand = 100
  end

  stock_item.backorderable = false
  stock_item.save!
  product_count += 1
end
puts "Stock updated for #{product_count} products"
puts "✅ Checkout setup completed!"
