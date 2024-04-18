// Example content of index.js
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";

window.Stimulus = Application.start();
const context = require.context("./", true, /_controller\.js$/);
Stimulus.load(definitionsFromContext(context));
