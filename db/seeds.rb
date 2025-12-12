# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

users = [
  {
    email: "user65@mojo.com",
    username: "Username65",
    password: "MyPass65"
  },
  {
    email: "user32@mojo.com",
    username: "Username32",
    password: "MyPass32"
  },
  {
    email: "user40@mojo.com",
    username: "Username40",
    password: "MyPass40"
  }
]

users.each do |user_data|
  User.find_or_initialize_by(email: user_data[:email]).tap do |u|
    u.username   = user_data[:username]
    u.password   = user_data[:password]
    u.save!
  end
end

# Load all seed files from db/seeds/ directory and its subdirectories
Dir[Rails.root.join("db/seeds/**/*.rb")].sort.each do |seed_file|
  puts "Seeding from #{seed_file}..."
  load seed_file
end


gift_statuses = {
  "Wishlisted" => GiftStatus.find_or_create_by!(status_name: "Wishlisted"),
  "Ordered"    => GiftStatus.find_or_create_by!(status_name: "Ordered"),
  "Delivered"  => GiftStatus.find_or_create_by!(status_name: "Delivered"),
  "Ignore"  => GiftStatus.find_or_create_by!(status_name: "Ignore"),
  "Default"  => GiftStatus.find_or_create_by!(status_name: "Default")
}

gift_statuses = {
  "Wishlisted" => GiftStatus.find_or_create_by!(status_name: "Wishlisted"),
  "Ordered"    => GiftStatus.find_or_create_by!(status_name: "Ordered"),
  "Delivered"  => GiftStatus.find_or_create_by!(status_name: "Delivered"),
  "Ignore"     => GiftStatus.find_or_create_by!(status_name: "Ignore"),
  "Default"    => GiftStatus.find_or_create_by!(status_name: "Default")
}

Gift.find_or_create_by!(
  name: "Bakugan",
  price: 20,
  purchase_url: "https://www.walmart.com/ip/Spin-Master-Bakugan-Evolutions-Battle-Strike-Pack-Refurbished/1084211273?wmlspartner=wlpa&selectedSellerId=101260274&sourceid=dsn_msft_f3bbf4a7-7bc0-446b-960a-1f453c921c64&veh=dsn&wmlspartner=dsn_msft_f3bbf4a7-7bc0-446b-960a-1f453c921c64&cn=FY26-MP-PMax_cnv_dps_dsn_dis_msft_mp_s_n&wl9=&wl11=Online&msclkid=a00683c18b4b13330b5aeaf77ff27ff6",
  description: "A transforming battle toy from the Bakugan series — great for kids who enjoy action figures.",
  status_id: gift_statuses["Wishlisted"].id,
  upvotes: 56,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Pokemon Cards",
  price: 15,
  purchase_url: "http://localhost:3000/",
  description: "A booster pack of collectible Pokémon trading cards—perfect for fans and collectors.",
  status_id: gift_statuses["Ordered"].id,
  upvotes: 65,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Blanket",
  price: 40,
  purchase_url: "http://localhost:3000/",
  description: "A warm, soft fleece blanket ideal for winter or cozy nights on the couch.",
  status_id: gift_statuses["Delivered"].id,
  upvotes: 665,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Xbox",
  price: 350,
  purchase_url: "http://localhost:3000/",
  description: "A next-generation gaming console offering high-performance graphics and entertainment options. A next-generation gaming console offering high-performance graphics and entertainment options. A next-generation gaming console offering high-performance graphics and entertainment options. A next-generation gaming console offering high-performance graphics and entertainment options.",
  status_id: gift_statuses["Default"].id,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Keyboard",
  price: 60,
  purchase_url: "http://localhost:3000/",
  description: "A mechanical keyboard with responsive switches—great for typing or gaming.",
  status_id: gift_statuses["Default"].id,
  creator_id: 3
)

Gift.find_or_create_by!(
  name: "LED Desk Lamp",
  price: 25,
  purchase_url: "http://localhost:3000/",
  description: "A brightness-adjustable LED lamp perfect for studying, reading, or office work.",
  status_id: gift_statuses["Default"].id,
  upvotes: 142,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Bluetooth Speaker",
  price: 45,
  purchase_url: "http://localhost:3000/",
  description: "Portable Bluetooth speaker with rich bass and long battery life for outdoor or indoor use.",
  status_id: gift_statuses["Default"].id,
  upvotes: 311,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Scented Candle Set",
  price: 30,
  purchase_url: "http://localhost:3000/",
  description: "A relaxing 3-pack of aromatic candles—perfect for unwinding at home.",
  status_id: gift_statuses["Default"].id,
  upvotes: 87,
  creator_id: 3
)

Gift.find_or_create_by!(
  name: "Art Sketchbook",
  price: 18,
  purchase_url: "http://localhost:3000/",
  description: "A high-quality sketchbook for artists—smooth paper ideal for pencils, pens, and markers.",
  status_id: gift_statuses["Default"].id,
  upvotes: 204,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Wireless Earbuds",
  price: 55,
  purchase_url: "http://localhost:3000/",
  description: "Noise-isolating wireless earbuds with touch controls and a compact charging case.",
  status_id: gift_statuses["Default"].id,
  upvotes: 496,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Travel Mug",
  price: 22,
  purchase_url: "http://localhost:3000/",
  description: "A stainless-steel insulated mug that keeps drinks hot or cold for hours.",
  status_id: gift_statuses["Default"].id,
  upvotes: 53,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Board Game",
  price: 35,
  purchase_url: "http://localhost:3000/",
  description: "A fun and strategic board game—great for family nights or group gatherings.",
  status_id: gift_statuses["Default"].id,
  upvotes: 421,
  creator_id: 3
)

Gift.find_or_create_by!(
  name: "Throw Pillow",
  price: 28,
  purchase_url: "http://localhost:3000/",
  description: "A cozy decorative pillow to add comfort and color to any living space.",
  status_id: gift_statuses["Default"].id,
  upvotes: 112,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Smartwatch Band",
  price: 15,
  purchase_url: "http://localhost:3000/",
  description: "A stylish replacement band compatible with popular smartwatch models.",
  status_id: gift_statuses["Default"].id,
  upvotes: 267,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Mini Succulent Plant",
  price: 12,
  purchase_url: "http://localhost:3000/",
  description: "A small, low-maintenance succulent—perfect for desks, shelves, or windowsills.",
  status_id: gift_statuses["Default"].id,
  upvotes: 39,
  creator_id: 3
)

Gift.find_or_create_by!(
  name: "Puzzle Set",
  price: 20,
  purchase_url: "http://localhost:3000/",
  description: "A 500-piece puzzle featuring a relaxing scenic design.",
  status_id: gift_statuses["Default"].id,
  upvotes: 178,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Water Bottle",
  price: 18,
  purchase_url: "http://localhost:3000/",
  description: "A lightweight, reusable water bottle with leak-proof design.",
  status_id: gift_statuses["Default"].id,
  upvotes: 84,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Car Air Freshener",
  price: 10,
  purchase_url: "http://localhost:3000/",
  description: "A long-lasting air freshener with a clean, refreshing scent.",
  status_id: gift_statuses["Default"].id,
  upvotes: 315,
  creator_id: 3
)

Gift.find_or_create_by!(
  name: "Notebook Set",
  price: 14,
  purchase_url: "http://localhost:3000/",
  description: "A set of three lined notebooks—perfect for journaling, notes, and planning.",
  status_id: gift_statuses["Default"].id,
  upvotes: 51,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Phone Stand",
  price: 16,
  purchase_url: "http://localhost:3000/",
  description: "Adjustable phone stand ideal for video calls, watching content, or desk setups.",
  status_id: gift_statuses["Default"].id,
  upvotes: 226,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Fuzzy Socks",
  price: 9,
  purchase_url: "http://localhost:3000/",
  description: "Warm and ultra-soft socks perfect for cold days or lounging at home.",
  status_id: gift_statuses["Default"].id,
  upvotes: 492,
  creator_id: 3
)

events = [
  {
    title: "Holiday Gift Exchange",
    event_date: Date.new(2025, 12, 20),
    location: "Cedar Rapids Community Center",
    budget: 200.00,
    theme: "Festive",
    user_id: 1,
    host_id: 1
  },
  {
    title: "Birthday Celebration",
    event_date: Date.new(2025, 7, 10),
    location: "Iowa City Park Pavilion",
    budget: 150.00,
    theme: "Outdoor Picnic",
    user_id: 2,
    host_id: 2
  },
  {
    title: "Friendsgiving Dinner",
    event_date: Date.new(2025, 11, 23),
    location: "Downtown Loft",
    budget: 300.00,
    theme: "Cozy Autumn",
    user_id: 3,
    host_id: 3
  },
  {
    title: "Game Night Gathering",
    event_date: Date.new(2025, 8, 14),
    location: "Username65's Apartment",
    budget: 75.00,
    theme: "Board Games",
    user_id: 1,
    host_id: 3
  },
  {
    title: "New Year's Bash",
    event_date: Date.new(2025, 12, 31),
    location: "Skyline Venue Hall",
    budget: 500.00,
    theme: "Black & Gold",
    user_id: 2,
    host_id: 1
  }
]

events.each do |event_data|
  Event.find_or_create_by!(
    title: event_data[:title],
    user_id: event_data[:user_id]
  ).update!(event_data)
end

gift_giver_entries = [
  # Event 1 assignments
  { event_id: 1, user_id: 1, recipient_id: 2, gift_id: 1 },
  { event_id: 1, user_id: 2, recipient_id: 3, gift_id: 2 },

  # Event 2 assignments
  { event_id: 2, user_id: 2, recipient_id: 1, gift_id: 3 },
  { event_id: 2, user_id: 3, recipient_id: 1, gift_id: 4 },

  # Event 3 assignments
  { event_id: 3, user_id: 3, recipient_id: 2, gift_id: 5 },
  { event_id: 3, user_id: 1, recipient_id: 3, gift_id: 1 },

  # Event 4 assignments
  { event_id: 4, user_id: 1, recipient_id: 3, gift_id: 2 },
  { event_id: 4, user_id: 3, recipient_id: 2, gift_id: 3 },

  # Event 5 assignments
  { event_id: 5, user_id: 2, recipient_id: 3, gift_id: 4 },
  { event_id: 5, user_id: 3, recipient_id: 1, gift_id: 5 }
]

gift_giver_entries.each do |entry|
  GiftGiver.find_or_create_by!(
    event_id: entry[:event_id],
    user_id: entry[:user_id],
    recipient_id: entry[:recipient_id]
  ).update!(entry)
end
