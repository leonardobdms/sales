require "faker"

Faker::Config.locale = "pt-BR"

SEED_COUNT = 25

puts "Seeding #{SEED_COUNT} orders..."

Order.destroy_all

statuses = Order.aasm.states.map(&:name)

SEED_COUNT.times do |index|
  Order.create!(
    customer_name: Faker::Name.name,
    address: Faker::Address.full_address,
    total_cents: rand(1_000..50_000),
    status: statuses[index % statuses.length]
  )
end

puts "Created #{Order.count} orders."
