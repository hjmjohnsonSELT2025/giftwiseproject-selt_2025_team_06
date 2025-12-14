// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chatbot"


// Password Visibility Toggle
document.addEventListener("turbo:load", function () {
    const passwordField = document.getElementById("password");
    const toggle = document.getElementById("toggle-password");

    if (passwordField && toggle) {
        toggle.addEventListener("change", function () {
            passwordField.type = toggle.checked ? "text" : "password";
        });
    }
});
