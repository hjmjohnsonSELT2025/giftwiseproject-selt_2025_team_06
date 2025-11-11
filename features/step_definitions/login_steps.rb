  Given(/the following users exist/) do |users_table|
    users_table.hashes.each do |user|
      # You can just use ActiveRecord calls to directly add movies to the database
      User.create!(email: user[:email], username: user[:username], password: user[:password])
    end
  end

  Given /^(?:|I )am on (.+)$/ do |page_name|
    visit path_to(page_name)
  end

  When(/I check the following ratings: (.*)/) do |rating_list|

  end

  Then(/(.*) seed users should exist/) do |n_seeds|
    expect(User.count).to eq n_seeds.to_i
  end

  Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |e1, e2|

  end

  And(/^I should (not )?see the following movies: (.*)$/) do |no, movie_list|

  end