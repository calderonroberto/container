Person persons[] = new Person[1];
boolean initialized = false;

//community values
int communityRating = 0;
 
//Some magic numbers
int CANVAS_W = 900;
int CANVAS_H = 700;
int CIRCLE_MARGIN = 50; //margin to keep betwen circle tangent and top of image
float CIRCLE_RADIUS = (CANVAS_H/2)-CIRCLE_MARGIN;       
int CIRCLE_X = CANVAS_H/2;
int CIRCLE_Y = CANVAS_H/2;
float CIRCLE_MOVEMENT = 0.0005;

// Some notes
// Processing.js doesn't really cast objects, which is fine, generally as 
// javascript will figure out things. However, when using a hashmap, it actually
// translates to a javascript 'object' which doesn't have the method 'get' 
// but you can access key/value pairs as variables: object.var






  void setup() {
      size(CANVAS_W,CANVAS_H);
      textSize(12);
      persons[0] = new Person(); //array needs to be initialized

      /* Development */
      //person 1      
      HashMap item = new HashMap();
      HashMap<String,String> person = new HashMap<String,String>();
      person.put("id", "1");
      person.put("name", "Person 1");
      person.put("rating", "22");
      item.put ("person",person);            
      HashMap<String,String> friend = new HashMap<String,String>();
      friend.put("id", "2");
      friend.put("favours_solved", "5");
      HashMap[] friends = new HashMap[1];
      friends[0] = friend;
      item.put("friends", friends);      


      //person 2
      HashMap item2 = new HashMap();
      HashMap<String,String> person2 = new HashMap<String,String>();
      person2.put("id", "2");
      person2.put("name", "Person 2");
      person2.put("rating", "2");
      item2.put ("person",person2);
      HashMap<String,String> friend2 = new HashMap<String,String>();
      friend2.put("id", "1");
      friend2.put("favours_solved", "2");
      HashMap[] friends2 = new HashMap[1];
      friends2[0] = friend2;      
      item2.put("friends", friends2);      



      HashMap[] data = new HashMap[2];
      data[0] = item;
      data[1] = item2;
      initCircles(data);
      
      /* End Development */
  }
  
  void draw() {
    background(255);
    
    if (initialized) {
      //drawPeopleLinks(); //draw all the links
      for (int p=0, end=persons.length; p<end;p++){
        	Person person = (Person) persons[p];
        	//person.drawPersonLinks();
        	person.draw();	
      }
      //drawInstructions();	    
    }    
  }

  void mousePressed() {
    /*
    for (int p=0, end=persons.length; p<end;p++){
      Person person = (Person) persons[p];
      if (mouseX > person.x-20 && mouseX < person.x +20 && mouseY > person.y-20 && mouseY < person.y+20){
	person.links = true;
      }
    }
    */
  }

  void mouseReleased() {
    /*
    for (int p=0, end=persons.length; p<end;p++){
      Person person = (Person) persons[p];
        person.links = false;
     
    }
    */
  }


  void initCircles(HashMap data[]) {

    int numPoints = data.length;
    float angleUnits=TWO_PI/float(numPoints);    
    for (int i=0; i< data.length;i++) {               
      HashMap dataItem = new HashMap();
      dataItem = (HashMap) data[i];
      HashMap person = (HashMap) dataItem.get("person");//HashMap person = (HashMap) dataItem.person;            
      HashMap friends[] = (HashMap[]) dataItem.get("friends"); //HashMap friends[] = (HashMap[]) dataItem.friends; 
      float angle = angleUnits*i;
      initPerson(person,friends,angle);
    }      
    
  }
/*
  void updateCircles(HashMap data[]){
    int rating = 0;  
    for (int i=0; i< data.length;i++) {         
      HashMap dataItem = (HashMap) data[i];     
      HashMap person = (HashMap) dataItem.get("person");//HashMap person = (HashMap) dataItem.person;      
      HashMap friends[] = (HashMap[]) dataItem.get("friends");//HashMap friends[] = (HashMap[]) dataItem.friends;      
      rating = rating  + (Integer) person.get("rating");//rating = rating  + person.rating;	      
      updatePerson(person,friends);
    }
    communityRating = rating; 
  }
*/


  void initPerson(HashMap person, HashMap friends[], float angle) {
    Person per = new Person(person, friends, angle);
    
    if (!initialized) { //if persons Array has not been initialized initialize       
      persons[0] = per;
      initialized = true;       
    } else {       
      //search if this person exists, if not, add.
      boolean exists = false;
      for (int i=0 ; i<persons.length;i++){
		  Person existent = (Person) persons[i];
  		  if ( existent.id == new Integer((String)person.get("id")) ){//if ( existent.id == (Integer)person.id ){
		      exists = true;           
		      break;
		  }
      }
      if ( exists == false ) {          
	  	  persons = (Person[]) append(persons, per); //might cause problems in js
      }
		    
    }     
  }

/*
  void updatePerson(HashMap person, HashMap friends[]) {
	  if (!initialized) { //prevent crashes if run before init.
                        float angle = 0;
			initPerson(person,friends,angle);
	  } else {
		  //search if this person exists, if it does update
	      boolean exists = false;
	      for (int i=0 ; i<persons.length;i++){
			  Person existent = (Person) persons[i];
			  if ( existent.id == (Integer)person.id ){ //if exists update
			      persons[i].name = person.name; //just in case it's modified
			      persons[i].id = person.id; //just in case 
		              persons[i].rating = person.rating;				   
			      persons[i].friends = friends;				                  

			      int maxNodeRatio = (((height/2)-CIRCLE_MARGIN)*TWO_PI)/(persons.length/6) ; //biggest circle.      
			      float factor =  ( person.rating / communityRating ) * maxNodeRatio;                   	  			 
			      persons[i].r = int(factor);				
			  }
	      }	       
	  } 	  
    }
*/
  class Person {     
    HashMap friends[];
    int x,y,id,rating,r; String name;
    float angle;
    boolean links;
    
    Person () {
    }
    
    Person (HashMap person, HashMap friends[], float angle) {
      this.angle = angle;
      this.id = new Integer((String)person.get("id"));//(Integer)person.id;
      this.rating = new Integer((String)person.get("rating"));;//(Integer)person.rating;
      this.name = (String)person.get("name");//(String)person.name;
      this.friends = friends;
      this.r = 10;
      this.links = false;
    }
	    
    void draw() {       
      if (this.links)
        drawPersonLinks();
      drawPerson();      
    }

    void drawPerson() {
      stroke(255,192,203);
      fill(173,255,47);	      
      
      strokeWeight(2);
            
      //ATTEMPTING TO MOVE ON THE CIRCLE

      this.angle = this.angle+CIRCLE_MOVEMENT;
      if (this.angle>=TWO_PI) this.angle=0.0;
      
      x = int(CIRCLE_RADIUS*sin(angle)) + CIRCLE_X  ; //translate to left side with a marg 
      y = int(CIRCLE_RADIUS*cos(angle)) + CIRCLE_Y; //translate to center   
            
      ellipse(x,y,r,r);
      fill(0);
      text(name,x,y);
    }

    void drawPersonLinks() {
	//for each friend
	for (int f=0 ; f<this.friends.length;f++){         
	  HashMap friend = (HashMap) friends[f];
	  
	  //if exists in our list of people available
	  for (int l=0; l<persons.length; l++){
	    Person existent = (Person) persons[l];    
	    if ( new Integer((String)friend.get("id")) == existent.id) { //if ( (Integer)friend.id == existent.id) {

	      float reciprocity = float(new Integer((String)friend.get("favours_solved"))); //float reciprocity = float((Integer)friend.favours_solved);
	      float rating = float(this.rating);				  
	      float factor =  ( reciprocity / rating ) * 10.0 ;                   
				      
	      int lineWeight = int(factor);                   
	      if (lineWeight > 10) lineWeight = 10; //max width is 10 pixels
	      strokeWeight(lineWeight);
	      line ( this.x, this.y, existent.x, existent.y);
	      break;
	    }                 
	  }                     
	}    
      }



    
  }
  
  /*
  void drawInstructions () {
  
      stroke(200);
      fill(255);
      rect(width-260,height-100, 260,100);
  
      stroke(255,192,203);
      fill(173,255,47);	      
      f1 = new PVector(width-120,height-80);
	  f2 = new PVector(width-100,height-10);
	  f3 = new PVector(width-250,height-20);
      int lw1 = 10;
      int lw2 = 2;
      
      strokeWeight(lw1);
	  line ( f1.x,f1.y,f2.x,f2.y);
	  strokeWeight(lw2);
	  line ( f1.x,f1.y,f3.x,f3.y);
	   
       
      //fulano
      strokeWeight(2);
      ellipse(f1.x,f1.y,30,30);
      ellipse(f2.x,f2.y,10,10);
      ellipse(f3.x,f3.y,7,7);
      
      fill(0);
      text("Como ler:", width-240,height-110);            
      text("Resolve mais",f1.x,f1.y);
      text("Resolve menos",f2.x,f2.y);
      
      //lines
      mp1 = new PVector ( (f1.x+f2.x)/2, (f1.y+f2.y)/2);
      text("Mais\ncooperação",mp1.x,mp1.y);      
      mp2 = new PVector ( (f1.x+f3.x)/2, (f1.y+f3.y)/2);
      text("Menos\ncooperação",mp2.x-40,mp2.y);
      
        
  }
  */
  
  
