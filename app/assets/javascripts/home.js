//= require jquery

$(document).ready(function() {
  initState();
  $("#checkin-notice").hide();
  checkCheckinEvents(); //check for events and update (not using thingbroker jquery plugin)
  //if you prefer to not use faye long pulling you can do synchronous calls [setting this up for now]
  setInterval(initState,  5000); 
});

function initState () {
  $.ajax({ type: "GET", url: "/api/state", dataType: "json", success: stateHandler });
};

// NOTE: We don't want to depend on loading a separate file (thingbroker jquery api)
// so we are writing an independent caller. Without the need to load external files.
function checkCheckinEvents(json) {
  if (json!=undefined && json[0]!=undefined){
     $("#checkin-notice").empty();
     $("#checkin-notice").append("<div class='checkin-notice-person'>"+json[0].info.user_name + " just checked in!</div>");
     $("#checkin-notice").fadeIn("slow", function(){
        //when done
	 setTimeout(function() {
	    $("#checkin-notice").fadeOut("slow");
	 }, 7000);	
     });
  }
  var events_url = "http://kimberly.magic.ubc.ca:8080/thingbroker/things/checkin"+localStorage.getItem("display_id")+"/events?waitTime=30";
  $.ajax({ type: "GET", url: events_url, dataType: "json", success: checkCheckinEvents });
}

function stateHandler (json) {
  var apps = json.apps;
  var staged_app = json.staged_app;
  var display_id = json.display.id;
  localStorage.setItem("display_id", json.display.id);//set global variable for ajaxcalls
  var thingbroker_url = encodeURIComponent(json.setup.thingbroker_url)
  var notes = json.notes;
  var interaction = json.interaction;
  if (typeof apps != 'undefined' ){ updateAppMenu(apps) };
  if (typeof staged_app != 'undefined' && staged_app != null){ updateAppContainer(staged_app, display_id, thingbroker_url) };
  if (typeof notes != 'undefined' ){ updateNotes(notes) };
  if (typeof interaction != 'undefined' ){ updateInstructions(interaction) };
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

function updateInstructions (interaction) {
   if (interaction.instructions == "true") {
      if (interaction.interacting == "false") {
         $("#interact-instructions").show("slow");
      } 
      if (interaction.interacting == "true") {
         $("#interact-instructions").hide("slow");   
      }
   }
   if (interaction.instructions == "false") {
      $("#interact-instructions").hide();   
   }
}

function updateAppContainer (staged_app, display_id, thingbroker_url) {
  if ($('.appcontainer').attr('id') != staged_app.id) {
    $(".appcontainer").attr('id', staged_app.id);
    $(".appthumbnail").animate({ borderWidth: 0 }, 100);
    $(".appthumbnail#"+staged_app.id).animate({ borderWidth: 4 }, 500);
    //var display=getCookie("display_id");    
    $(".appcontainer").attr('src', staged_app.url+"?display_id="+display_id+"&thingbroker_url="+thingbroker_url);
  }
}

function updateNotes (notes) {
  var notecount = notes.length;
  $(".note").remove()
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
  //resize thumbnails to fit app menu nicely  
  var appmenuheight = $(".appmenu").height();
  var appmenuwidth = $(".appmenu").width();
  var appcount = apps.length;
  var thumbnailsize = (appmenuheight/2.5)/appcount;
  if (thumbnailsize > 80 ) { thumbnailsize = 80 };
  if (thumbnailsize > appmenuwidth ) { thumbnailsize = appmenuwidth };
  //if on request but not on DOM, add
  $.each(apps, function() {
     if (this.thumbnail_url == "app_thumbnail.png") {
       this.thumbnail_url = "assets/app_thumbnail.png";
     }
     if ($(".appthumbnail#"+this.id).length == 0){
       //append object
       //$(".appmenu").append("<img src='"+this.thumbnail_url+
       // "' class='appthumbnail' id='"+this.id+"'></img>");
       $(".appmenu").append("<img src='"+this.thumbnail_url+
         "' class='appthumbnail' id='"+this.id+"' width='"+
         thumbnailsize+"px' height='"+thumbnailsize+"px'></img>");

       //bind to ajax call to stage app if clicked
       $(".appthumbnail#"+this.id).live("click", function(){
                                         $(this).animate({borderWidth: 1}, 100);
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

