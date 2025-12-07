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