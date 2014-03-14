//= require jquery

$(document).ready(function() {
  initState();
  //if you prefer to not use faye long pulling you can do synchronous calls [setting this up for now]
  setInterval(initState,  5000); 
});

function initState () {
  $.ajax({ type: "GET", url: "/api/state", dataType: "json", success: stateHandler });
};
function stateHandler (json) {
  var apps = json.apps;
  var staged_app = json.staged_app;
  var display_id = json.display.id;
  var thingbroker_url = encodeURIComponent(json.setup.thingbroker_url)
  var notes = json.notes;
  if (typeof apps != 'undefined' ){ updateAppMenu(apps) };
  if (typeof staged_app != 'undefined' && staged_app != null){ updateAppContainer(staged_app, display_id, thingbroker_url) };
  if (typeof notes != 'undefined' ){ updateNotes(notes) };
};

//use long-polling with faye to update DOM as needed.
$(function() {
/* Disabling as kimberly has no access to such port
  var hostname = window.location.hostname;
  var faye = new Faye.Client("http://"+hostname+":9292/faye");
  var display=getCookie("display_id");
  var url = "/states/"+display;
  faye.disable('autodisconnect');
  faye.subscribe(url, function (data) {
    stateHandler(data)
  });
*/
});

function updateAppContainer (staged_app, display_id, thingbroker_url) {
  if ($('.appcontainer').attr('id') != staged_app.id) {
    $(".appcontainer").attr('id', staged_app.id);
    //var display=getCookie("display_id");    
    $(".appcontainer").attr('src', staged_app.url+"?display_id="+display_id+"&thingbroker_url="+thingbroker_url);
  }
}

function updateNotes (notes) {
  var notecount = notes.length;
 
  $(".messageboard").empty()
  $.each(notes, function() {
    var from = $(this)[0].from;
    var message = $(this)[0].message;
    $(".messageboard").append("<div class='note'>"+message+"</div>");
    if (notecount > 4) {
      $(".messageboard :last-child").remove()
    }; 
  });
}

function updateAppMenu (apps) {

  var appmenuheight = $(".appmenu").height();
  var appmenuwidth = $(".appmenu").width();
  var appcount = apps.length;
  var thumbnailsize = appmenuheight/appcount;
  if (thumbnailsize > 80 ) { thumbnailsize = 80 };
  if (thumbnailsize > appmenuwidth ) { thumbnailsize = appmenuwidth };

  //if on request but not on DOM, add
  $.each(apps, function() {
     if (this.thumbnail_url == "app_thumbnail.png") {
       this.thumbnail_url = "assets/app_thumbnail.png";
     }
     if ($(".appthumbnail#"+this.id).length == 0){
       //append object
       $(".appmenu").append("<img src='"+this.thumbnail_url+
         "' class='appthumbnail' id='"+this.id+"' width='"+
         thumbnailsize+"px' height='"+thumbnailsize+"px'></img>");
       //bind to ajax call to stage app if clicked
       $(".appthumbnail#"+this.id).live("click", function(){
                                         var id = $(this).attr('id');
                                         var data = {staging: {app_id: id}};
                                         $.ajax({
                                           type: 'POST',
                                           url: '/stagings',
                                           data: data,
                                           headers: {
                                             'X-Transaction': 'POST Example',
                                             'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
                                           }
                                         });                                            
       });  
     }       
   });

  //clear unused: if on DOM but not on request, remove
  $('.appmenu').find('img').each(function () {
     //resize images if needed now that you're iterating through them
     $(this).width(thumbnailsize); $(this).height(thumbnailsize);
     var id = $(this).attr('id')
     var exists = false;
     $.each(apps, function() {
       if ( this.id == id ) {
          exists = true;
          return false;       
       }       
     });
     if (exists == false) {
       $(".appmenu").find('.appthumbnail#'+id).remove();
     }
  });
};





function getCookie(c_name)
{
var i,x,y,ARRcookies=document.cookie.split(";");
for (i=0;i<ARRcookies.length;i++)
  {
  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
  x=x.replace(/^\s+|\s+$/g,"");
  if (x==c_name)
    {
    return unescape(y);
    }
  }
};

