# User + Friendship setup
#
Given("the following basic users exist:") do |users_table|
  users_table.hashes.each do |row|
    User.find_or_create_by!(username: row["username"]) do |u|
      u.email = row["email"]
      u.password = "password123"
      u.password_confirmation = "password123"
    end
  end
end

Given("the following friendships exist:") do |table|
  table.hashes.each do |row|
    user   = User.find_by!(username: row["user"])
    friend = User.find_by!(username: row["friend"])

    Friendship.find_or_create_by!(
      user: user,
      friend: friend
    ) do |f|
      f.status = row["status"]
    end
  end
end

Given("{string} and {string} are friends") do |u1, u2|
  user1 = User.find_by!(username: u1)
  user2 = User.find_by!(username: u2)

  Friendship.find_or_create_by!(user: user1, friend: user2, status: "accepted")
end

# Viewing friends

Then("I should see {string} in my friends list") do |username|
  expect(page).to have_content(username)
end

Then("I should not see {string} in my friends list") do |username|
  expect(page).not_to have_content(username)
end

# Sending friend requests

When("I enter {string} in the friend username box") do |username|
  fill_in "username", with: username
end

When("I add {string} as a friend") do |username|
  fill_in "username", with: username
  click_button "Add Friend"
end

Then("{string} should receive a friend request") do |username|
  user = User.find_by!(username: username)

  expect(
    Friendship.where(friend: user, status: "pending").count
  ).to be > 0
end

# Accepting / declining requests

Given("{string} has sent a friend request to {string}") do |sender, receiver|
  sender_user   = User.find_by!(username: sender)
  receiver_user = User.find_by!(username: receiver)

  Friendship.find_or_create_by!(
    user: sender_user,
    friend: receiver_user,
    status: "pending"
  )
end

When("I accept the friend request from {string}") do |username|
  within(".friend-requests") do
    within("li", text: username) do
      click_button "Accept"
    end
  end
end

Then("{string} should appear in my friends list") do |username|
  expect(page).to have_content(username)
end

# Removing friends

When("I press {string} next to {string}") do |button, username|
  within("li", text: username) do
    click_button button
  end
end
# Prevent self-friending

When("I try to add myself as a friend") do
  fill_in "username", with: @logged_in_username
  click_button "Add Friend"
end

