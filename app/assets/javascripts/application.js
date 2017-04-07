// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require star-rating.min
//= require bootstrap
//= require jquery.raty
//= require ratyrate
//= require bootstrap-tagsinput
//= require jquery.slimscroll
//= require app
//= require Chart.bundle
//= require chartkick
//= require datetimepicker
//= require growl
//= require jquery.transit.min
//= require_tree .
//= require social-share-button
//= require i18n.js
//= require i18n/translations

$(document).ready(function () {
  $('.alert').fadeOut(5000);
});

if(navigator.userAgent.toLowerCase().indexOf('firefox') > -1){
  alert(I18n.t("warning_firefox"));
}