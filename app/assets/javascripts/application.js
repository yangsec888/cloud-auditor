// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require jquery.turbolinks
//= require bootstrap.min
//= require rails.validations
//= require jstree
//= require codemirror
//= require yaml
//= require popup
//= require_tree .
$(document).ready(function(){

  function fadeAlert(){
    $('.alert-temp').removeClass('in');
  }

  function removeAlert(){
    $('.alert-temp').remove();
  }

  window.setTimeout(fadeAlert,3000);
  window.setTimeout(removeAlert,3000);

  // Popover Management
  $(function (){
    $("[data-toggle='popover']").popover({html:true});
  });


  $('.dropdown-toggle').dropdown();
});
