//= require jquery
//A handy screen resizing function. This will resize the iframe for the mobile
// app to the screen size. Bootstrap will resize this, so in show.html.erb
// we will make sure it's corrected if changed.
// Bootstrap overrides our attempts to properly resize the iframe with css.
// On some devices bootstrap utilizes the device max-screen capabilities (e.g. 700+)
// but zooms at 350px, leaving some of the iframe out. I had to use some jquery
// to solve this.

$('document').ready(function() {
   window.updateIframe = function() {
     var h = $(window).height();
     var w = $(window).width();
     $(".mobileappcontainer").height(h - 80);
     $(".mobileappcontainer").width(w);
   }
setTimeout(function(){
 window.updateIframe();
}, 1000);
});

