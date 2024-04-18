// Importing Bootstrap and Turbo
import "@hotwired/turbo-rails"
import "bootstrap"

// Import custom styles
import '../stylesheets/application'

// Stimulus setup
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("../controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

function updateTaxAndTotal(addressId) {
  fetch(`/payments/calculate_tax?address_id=${addressId}`)
    .then(response => response.json())
    .then(data => {
      document.getElementById('tax').innerText = data.tax;
      document.getElementById('total').innerText = data.total;
    })
    .catch(error => console.error('Error updating tax and total:', error));
}
