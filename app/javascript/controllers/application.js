// app/javascript/controllers/application_controller.js
import { Controller } from "@hotwired/stimulus"

// Example of a simple Stimulus controller
export default class extends Controller {
  connect() {
    console.log("Application controller is connected");
  }
}
