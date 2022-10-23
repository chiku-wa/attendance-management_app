// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// ========== Railsデフォルト
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

// ========== Railsデフォルト以外で、汎用的に使用するライブラリなどの設定
// ----- yarnで導入したjQuery,Popper,Bootstrapを使用するための設定
require("jquery/dist/jquery.js");
require("@popperjs/core/dist/esm/popper.js");
// bootstrapは、各JavaScriptでインスタンス変数として用いるため、bootstrap変数に代入しておく
bootstrap = require("bootstrap/dist/js/bootstrap.js");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// ========== React関連の設定(React導入時に追記された設定)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
