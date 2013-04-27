import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class c_ants extends PApplet {

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

ArrayList<Ant> ants;
PGraphics foodMap;
PGraphics pheroMap;
PImage foodMapImage;

public void setup() {
  size(700,700, P2D);
  frameRate(40);
  
  pheroMap = createGraphics(width, height);
  pheroMap.beginDraw();
  pheroMap.background(255);
  pheroMap.endDraw();

  foodMap = createGraphics(width, height);
  foodMap.beginDraw();
  foodMap.background(255);
  foodMap.noFill();

  foodMap.strokeWeight(8);
  
  
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(noise(i*.01f,j*.01f)>.65f){
        foodMap.stroke(0, (int)(noise(i*.01f,j*.01f)*60), (int)(noise(i*.01f,j*.01f)*30));
        foodMap.point(i,j);
      }
  }  
  foodMap.endDraw();
  }

   ants = new ArrayList<Ant>();
  // Add an initial set of ants into the system
  for (int i = 0; i < width*height/500; i++) {
    //for (int i = 0; i < 10; i++) {
    Ant t = new Ant();
    ants.add(t);
  }
}

public void draw() {


  background(255, 250, 220);
  
  image(foodMap, 0, 0);

  tint(255, 200);
  image(pheroMap, 0, 0);
  

  pheroMap.beginDraw();
  // fade out pheroMap
  pheroMap.noStroke();
  pheroMap.noSmooth();
  pheroMap.fill(255, 255, 255, 1);
  pheroMap.rect(0,0,width,height);

  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  
  int numFood = 0;
  for (Ant t : ants) {
      t.run(); 
  }

  foodMap.endDraw();
  pheroMap.endDraw();

  stroke(0);
  strokeWeight(20);
  point(width/2, height/2);
  
 // println(numFood);
}



class Ant {

  PVector location;
  PVector direction;
  PVector home;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();
  int maxHistoryLength = 50;
  int pheroPower = 0;

  Ant() {

    home = new PVector(width/2, height/2);
    location = new PVector(home.x, home.y);
    direction = pickDirection();
  }

  public PVector pickDirection() {
    // first, check pheroMap
    int bestPhero = 255;
    int pheroTest = 255;
    PVector newDirection = new PVector(0,0);

    int numSteps = 32;
    float start = random(1f);
    for (int i=0; i<numSteps; i++){
      float angle = (start+1.0f*i/numSteps)*2*3.1415f;
      PVector testDirection = new PVector((float) Math.cos(angle), (float) Math.sin(angle));
      int col = pheroMap.get((int) (location.x+testDirection.x + width) % width, (int) (location.y + testDirection.y + height) % height );
      pheroTest = (int) green(col);
      
      if( pheroTest < bestPhero){
          newDirection = testDirection;
          bestPhero = pheroTest;
      }
    }


    if(newDirection.mag()>.001f) {

      return newDirection;
    }
    newDirection = new PVector(random(100)-50,random(100)-50);
    newDirection.setMag(1);
    return newDirection;
  }

  public void run() {
    update();
    render();
  }


  public Boolean isAtHome() {
    return new PVector(location.x-home.x, location.y-home.y).mag()<10;
  }
 
  // Method to update location
  public void update() {
    if(!carriesFood && random(100)>80 && green(pheroMap.get((int)location.x, (int)location.y))==255) {
      direction = pickDirection();
    }

    if(carriesFood){
      direction = new PVector(home.x - location.x, home.y - location.y);
      direction.setMag(1);
    }

    if(isAtHome() && carriesFood){
      dropFood(location);
      pickDirection();
    }

    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);
    

    nextPos.x = (nextPos.x + width) % width;
    nextPos.y = (nextPos.y + height) % height;
    
    // println(nextPos.x);

    int col = foodMap.get((int) nextPos.x, (int) nextPos.y);

    if(brightness(col) < 255){
        action = true;

        if(carriesFood){
          // try to drop food
          carriesFood = !dropFood(location);
          nextPos = location;
        } else {
          // pick up food
          carriesFood = pickUpFood(nextPos);
        }
    } else{
      action = false;
    }
    location = nextPos;

    if(carriesFood && pheroPower>0){
      pheroMap.stroke(255, 0, 100, pheroPower);
      pheroMap.strokeWeight(5);
      pheroMap.point(location.x, location.y);
      pheroPower--;
    }

  }

  public Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(3);
    foodMap.point((int) location.x, (int) location.y);
    pheroPower = (int) (new PVector(home.x - location.x, home.y - location.y).mag()*.66f);
    return true;
  }
  
  public Boolean dropFood(PVector location) {
    foodMap.stroke(0);
    foodMap.strokeWeight(1);
    carriesFood = false;
    //foodMap.point((int) location.x, (int) location.y);
    return true;
  }

  public void render() {
    
    if(action){
      stroke(255,0,0);  
      strokeWeight(2); 
    } else {

      if(carriesFood){
        stroke(0); 
        strokeWeight(3);  
      } else {
        stroke(0,150); 
        strokeWeight(2);  
      } 
    }
    point(location.x, location.y);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "c_ants" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
