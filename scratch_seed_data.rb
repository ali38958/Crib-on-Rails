ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")
Product.delete_all
Category.delete_all
ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")

category_names = [
  "Electronics",
  "Clothing",
  "Home & Garden",
  "Sports & Outdoors",
  "Books",
  "Toys & Games",
  "Health & Beauty"
]

categories = category_names.map { |name| Category.create!(name: name) }

prefixes = ["Premium", "Essential", "Advanced", "Classic", "Modern", "Ultra", "Smart", "Eco-friendly", "Luxury", "Compact"]
items = {
  "Electronics" => ["Smartphone", "Laptop", "Headphones", "Tablet", "Monitor", "Keyboard", "Mouse", "Speaker", "Camera", "Smartwatch"],
  "Clothing" => ["T-Shirt", "Jeans", "Jacket", "Sneakers", "Dress", "Sweater", "Socks", "Hat", "Scarf", "Gloves"],
  "Home & Garden" => ["Sofa", "Dining Table", "Lamp", "Rug", "Plant Pot", "Bed Frame", "Pillow", "Blanket", "Vase", "Mirror"],
  "Sports & Outdoors" => ["Yoga Mat", "Dumbbells", "Tent", "Sleeping Bag", "Water Bottle", "Bicycle", "Tennis Racket", "Basketball", "Running Shoes", "Backpack"],
  "Books" => ["Novel", "Biography", "Cookbook", "Sci-Fi Book", "History Book", "Poetry Collection", "Dictionary", "Encyclopedia", "Comic Book", "Art Book"],
  "Toys & Games" => ["Board Game", "Action Figure", "Puzzle", "Lego Set", "Doll", "Remote Control Car", "Stuffed Animal", "Card Game", "Video Game", "Yo-yo"],
  "Health & Beauty" => ["Shampoo", "Face Cream", "Lipstick", "Perfume", "Toothbrush", "Vitamins", "Sunscreen", "Lotion", "Makeup Brush", "Nail Polish"]
}
suffixes = ["Pro", "Max", "Plus", "Lite", "Elite", "Series X", "Edition", "Pack", "Kit", "Bundle"]

100.times do
  cat = categories.sample
  
  # Generate a name
  prefix = prefixes.sample
  item = items[cat.name].sample
  suffix = [suffixes.sample, ""].sample
  
  name = [prefix, item, suffix].reject(&:blank?).join(" ")
  
  Product.create!(
    name: name,
    category_id: cat.id,
    quantity: rand(0..150),
    current_price: rand(5.0..999.99).round(2)
  )
end

puts "Database seeded with 7 categories and 100 products!"
