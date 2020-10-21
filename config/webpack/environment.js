const {
  environment
} = require('@rails/webpacker')
const erb = require('./loaders/erb')

// jQueryを利用するための設定
const webpack = require("webpack")
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery/src/jquery",
    jQuery: "jquery/src/jquery"
  })
)

environment.loaders.prepend('erb', erb)
module.exports = environment
