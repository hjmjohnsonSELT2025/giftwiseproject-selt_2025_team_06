# Configure Capybara to use a JavaScript-capable driver for @javascript tagged scenarios
# This file only affects scenarios tagged with @javascript in generate_gift_ideas.feature

Before('@javascript') do
  # For Rails 7 with Turbo, we can try using selenium_chrome_headless
  # If selenium-webdriver is not installed, this will fail gracefully
  begin
    require 'selenium-webdriver'
    Capybara.javascript_driver = :selenium_chrome_headless
  rescue LoadError
    # If selenium is not available, try using rack_test with Turbo support
    # Note: This may not work for all JavaScript interactions
    Capybara.current_driver = :rack_test
    puts "Warning: selenium-webdriver not found. JavaScript tests may not work correctly."
    puts "Add 'selenium-webdriver' to your Gemfile test group for full JavaScript support."
  end
end

# Reset to default driver after JavaScript scenarios
After('@javascript') do
  Capybara.use_default_driver
end

