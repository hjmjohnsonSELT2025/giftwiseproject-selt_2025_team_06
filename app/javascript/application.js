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
function sortChoice(listId, choice) {
    const list = document.getElementById(listId);
    const items = Array.from(list.querySelectorAll("li"));

    if (choice === "alpha") {
        items.sort((a, b) => a.textContent.localeCompare(b.textContent));
    } else if (choice === "added") {
        items.sort((a, b) => {
            return parseInt(a.getAttribute("data-added")) - parseInt(b.getAttribute("data-added"));
        });
    }

    list.innerHTML = "";
    items.forEach(item => list.appendChild(item));
}