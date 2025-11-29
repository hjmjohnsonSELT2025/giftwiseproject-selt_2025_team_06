# db/seeds/preferences.rb

puts "Seeding preferences..."

preferences = %w[
  chocolate
  perfume
  wallet
  candle
  mug
  scarf
  watch
  plant
  socks
  puzzle
]

preferences.each do |name|
  Preference.find_or_create_by!(name: name)
end

puts "Preferences seeded!"