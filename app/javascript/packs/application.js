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

