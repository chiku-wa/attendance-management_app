// ==================================================
// モバイルアクセス時のハンバーガーメニューの制御を行う処理
// ==================================================
//
// 【前提】
// PCアクセス時は「.nav-wrap」適用し、モバイルアクセス時は「.nav-wrap.open」と「.nav-wrap.close」
// を本jQueryスクリプトで動的に切り替える。
//
// 【対応するCSS】common.scss
//
// ハンバーガーメニュー(3本線)をクリックしたときに、以下の通りCSSを切り替える
//
// １．メニューを閉じる場合(× → 三 に切り替え)
//   ・「.nav-button.active」→「.nav-button」にCSSを切り替える
//   ・「.nav-wrap.open」→「.nav-wrap.close」にCSSを切り替える
//
// ２．メニューを開く場合(三 → × に切り替え)
//   ・「.nav-button」→「.nav-button.active」にCSSを切り替える
//   ・「.nav-wrap.close」→「.nav-wrap.open」にCSSを切り替える
//
// 【留意事項】
// イベント制御には「$('.nav-button').on('click', function () {〜」は用いず、$(document)記法を用いる。
// ※前者はaタグにしか反応しないイベントであり、ページがリロードされてJavaScriptが正常に動作
// しなくなるため、divでもイベントを取得できる後者を用いる。


// ★デバッグ用★
$(document).ready(function () {
  // ２．メニューを開く
  $(this).addClass('active');
  $('.nav-wrap').addClass('open').removeClass('close');
});

$(document).ready(function () {
  $('.nav-button').click(function () {

    if ($(this).hasClass('active')) {
      // １．メニューを閉じる
      $(this).removeClass('active');
      $('.nav-wrap').addClass('close').removeClass('open');
    } else {
      // ２．メニューを開く
      $(this).addClass('active');
      $('.nav-wrap').addClass('open').removeClass('close');
    }
  });

});
