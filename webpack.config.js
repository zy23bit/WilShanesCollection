const path = require("path");
const webpack = require("webpack");

module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: {
    application: "./app/javascript/application.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    chunkFormat: "array-push",
    path: path.resolve(__dirname, "app/assets/builds"),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules\/(?!(hotwired|other-module-needing-transpile)\/).*/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ['@babel/preset-env'], // Presets used for transpiling
            plugins: ['@babel/plugin-proposal-optional-chaining'] // Additional plugins
          }
        }
      }
    ]
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ],
};
