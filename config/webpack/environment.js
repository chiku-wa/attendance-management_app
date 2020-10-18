const {
  environment
} = require('@rails/webpacker')

// jQueryを利用するための設定
const webpack = require("webpack")
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery/src/jquery",
    jQuery: "jquery/src/jquery"
  })
)

module.exports = environment
