//= require jquery

var interacting = false;

$(document).ready(function() {
  initState();
  $("#checkin-notice").hide();
  checkCheckinEvents(); //check for events and update (not using thingbroker jquery plugin)
  //if you prefer to not use faye long pulling you can do synchronous calls [setting this up for now]

  //Resize url according to this display
/*
  $('.qrcodeurl').each(function(){
    var divWidth = $(this).width();
    var divHeight = $(this).height();
    var newFontSize = Math.min(divWidth, divHeight);
    $(this).css({"font-size":newFontSize/1.3});  
  });
*/
  $('.qrcodeurl').css({"font-size": $('.qrcodeurl').height()/1.3})
  $('#interact-instructions-video').css({"width": $('#instructions-block').width() * 0.9})
  

/*
  $('#lots div').each(function(){
		  var divWidth = $(this).width();
		  var divHeight = $(this).height();
 		  var newFontSize = Math.min(divWidth, divHeight);
		  var checkinsSize = newFontSize/3;
		  var nameSize = newFontSize/6;
   	   	  $(".checkins").css({"font-size" : checkinsSize});
   	   	  $(".name").css({"font-size" : nameSize});
   	   	  $(this).css({"background" : ":url(img/01.jpg)"});
		});
*/
  setInterval(initState,  5000); 
  setInterval(toggleAdvertisement,  20000);  //300000 = five minutes
});

function passingInstructions () {
    if (interacting == false) {
    	$("#interact-instructions").css({ "left": "-500px"});	
        $("#interact-instructions").animate({ "left": "100%"}, 80000, "linear", function(){ passingInstructions(); });	               
    }
} 

function toggleAdvertisement() {
   if (interacting == false) {
      $("#advertisement").fadeToggle(5000);
   }
   if (interacting == true) {
      $("#advertisement").hide("slow");
   }

}


function initState () {
  $.ajax({ type: "GET", url: "/api/state", dataType: "json", success: stateHandler });
};

// NOTE: We don't want to depend on loading a separate file (thingbroker jquery api)
// so we are writing an independent caller. Without the need to load external files.
function checkCheckinEvents(json) {
  if (json!=undefined && json[0]!=undefined){
     $("#checkin-notice").empty();
     $("#checkin-notice").append("<div class='checkin-notice-person'>"+json[0].info.user_name + " just watered the garden!</div>");
     $("#checkin-notice").fadeIn("slow", function(){
        //when done
	 setTimeout(function() {
	    $("#checkin-notice").fadeOut("slow");
	 }, 7000);	
     });
  }
  //QTWeb throws error on localstorage
  //var events_url = "http://kimberly.magic.ubc.ca:8080/thingbroker/things/checkin"+localStorage.getItem("display_id")+"/events?waitTime=30";
  var displayId=getCookie("display_id");    
  var events_url = "http://kimberly.magic.ubc.ca:8080/thingbroker/things/checkin"+displayId+"/events?waitTime=30";
  $.ajax({ type: "GET", url: events_url, dataType: "json", success: checkCheckinEvents });
}

function stateHandler (json) {
  var apps = json.apps;
  var staged_app = json.staged_app;
  var display_id = json.display.id;
  //QTWeb throws error on localstorage
  //if display_id != undefined {
  //  localStorage.setItem("display_id", json.display.id);//set global variable for ajaxcalls
  //}
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
	 interacting = false;
	 //passingInstructions(); //animate instructions!
      } 
      if (interaction.interacting == "true") {
         $("#interact-instructions").hide("slow");
         $("#advertisement").hide("slow");      
	 interacting = true;
      }
   }
   if (interaction.instructions == "false") {
      $("#interact-instructions").hide();   
      $("#advertisement").hide("slow");      
      interacting = true;
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
    var thumbnail = $(this)[0].user_thumbnail_url;
    if (thumbnail == null) {
       thumbnail = "/img/anonymous-thumbnail.jpg"
    }
    var message = $(this)[0].message;
    $(".messageboard").append("<div class='note'><img class='note-user-thumbnail' src='"+thumbnail+"'></img><span class='note-text'>"+message+"</span></div>");
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

