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

Gift.find_or_create_by!(
  name: "Bakugan",
  price: 20,
  purchase_url: "https://www.walmart.com/ip/Spin-Master-Bakugan-Evolutions-Battle-Strike-Pack-Refurbished/1084211273?wmlspartner=wlpa&selectedSellerId=101260274&sourceid=dsn_msft_f3bbf4a7-7bc0-446b-960a-1f453c921c64&veh=dsn&wmlspartner=dsn_msft_f3bbf4a7-7bc0-446b-960a-1f453c921c64&cn=FY26-MP-PMax_cnv_dps_dsn_dis_msft_mp_s_n&wl9=&wl11=Online&msclkid=a00683c18b4b13330b5aeaf77ff27ff6",
  status_id: gift_statuses["Wishlisted"].id,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Pokemon Cards",
  price: 15,
  purchase_url: "http://localhost:3000/",
  status_id: gift_statuses["Ordered"].id,
  creator_id: 1
)

Gift.find_or_create_by!(
  name: "Blanket",
  price: 40,
  purchase_url: "http://localhost:3000/",
  status_id: gift_statuses["Delivered"].id,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Xbox",
  price: 350,
  purchase_url: "http://localhost:3000/",
  status_id: gift_statuses["Default"].id,
  creator_id: 2
)

Gift.find_or_create_by!(
  name: "Keyboard",
  price: 60,
  purchase_url: "http://localhost:3000/",
  status_id: gift_statuses["Default"].id,
  creator_id: 3
)