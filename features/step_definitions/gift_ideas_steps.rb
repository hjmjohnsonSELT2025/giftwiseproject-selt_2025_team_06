Given("the following gift ideas exist:") do |table|
  table.hashes.each do |row|
    status = GiftStatus.find_or_create_by(status_name: row["gift_status"])

    Gift.create!(
      name: row["name"],
      price: row["price"],
      purchase_url: row["purchase_url"],
      description: row["description"],
      upvotes: row["upvotes"],
      status_id: status.id,
      creator_id: User.first&.id || FactoryBot.create(:user).id
    )
  end
end