Faker::Config.locale = 'en-CA'
# Clear existing data to avoid duplication issues
OrderItem.destroy_all
Order.destroy_all
Cart.destroy_all
CartItem.destroy_all
Address.destroy_all
User.destroy_all
Product.destroy_all
Category.destroy_all
StaticPage.destroy_all


# Create Admin User
unless AdminUser.exists?(email: 'admin@example.com')
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end
# Constants
USER_COUNT = 10
CATEGORY_COUNT = 5
PRODUCT_COUNT = 20
ORDER_COUNT = 30
CART_ITEM_COUNT = 50
ADDRESS_COUNT = 2

# Create Users
USER_COUNT.times do
  User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password123',  # Devise will automatically encrypt this password
    password_confirmation: 'password123'
  )
end

# Create address
users = User.all  # This will fetch all users from the database

# Create Addresses
users.each do |user|
  ADDRESS_COUNT.times do
    Address.create!(
      user: user,
      address: Faker::Address.full_address,
      city: Faker::Address.city,
      province: Faker::Address.state_abbr,
      zip: Faker::Address.zip_code
    )
  end
end

# Create Categories
CATEGORY_COUNT.times do
  Category.create!(
    name: Faker::Commerce.department,
    description: Faker::Lorem.sentence
  )
end

# Create Products
PRODUCT_COUNT.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.sentence,
    price: Faker::Commerce.price(range: 10..100.0),
    category_id: Category.order('RANDOM()').first.id,
    featured: [true, false].sample,
    onSale: [true, false].sample,
    discount: rand(5..20),
    sales_price: Faker::Commerce.price(range: 5..50.0)
  )
end

# Create Carts and Cart Items
USER_COUNT.times do |i|
  cart = Cart.create!(user_id: User.offset(i).first.id)
  CART_ITEM_COUNT.times do
    CartItem.create!(
      cart_id: cart.id,
      product_id: Product.order('RANDOM()').first.id,
      quantity: rand(1..5)
    )
  end
end

# Create Orders and Order Items
USER_COUNT.times do |i|
  ORDER_COUNT.times do
    order = Order.create!(
      user_id: User.offset(i).first.id,
      total_with_tax: Faker::Commerce.price(range: 100..500.0),
      status: rand(0..4)
    )
    OrderItem.create!(
      order_id: order.id,
      product_id: Product.order('RANDOM()').first.id,
      quantity: rand(1..5),
      price_at_time: Faker::Commerce.price(range: 10..100.0)
    )
  end
end

# Create Static Pages
StaticPage.create!(title: 'About Us', content: Faker::Lorem.paragraph)
StaticPage.create!(title: 'Contact Us', content: Faker::Lorem.paragraph)

# Output Seed Data Summary
puts "Seeded #{User.count} users."
puts "Seeded #{Category.count} categories."
puts "Seeded #{Product.count} products."
puts "Seeded #{Order.count} orders with #{OrderItem.count} items."
puts "Seeded #{Address.count} addresses."
puts "Created static pages: About Us, Contact."
