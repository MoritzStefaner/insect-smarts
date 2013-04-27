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

public class a_termites extends PApplet {

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

ArrayList<Termite> termites;
PGraphics foodMap;
PImage foodMapImage;

public void setup() {
  size(200,200);
  frameRate(20);
  
  termites = new ArrayList<Termite>();
  // Add an initial set of termites into the system
  for (int i = 0; i < width*height/10; i++) {
    //for (int i = 0; i < 10; i++) {
    Termite t = new Termite();
    termites.add(t);
  }
  

  foodMap = createGraphics(width, height);
  foodMap.beginDraw();
  foodMap.background(255);
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  foodMap.stroke(0);
  
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(random(100)>80){
        foodMap.point(i,j);
      }
  }  
  foodMap.endDraw();
  }
}

public void draw() {
  background(255, 250, 220);
  
  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  int numFood = 0;
  for (Termite t : termites) {
      t.run(); 
  }
  for (Termite t : termites) {
      if (t.carriesFood) numFood++;
  }
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(brightness(foodMap.get(i,j))<255) numFood++;
    }  
  }

  foodMap.endDraw();

  image(foodMap, 0, 0);
  //println(numFood);
}



class Termite {

  PVector location;
  PVector direction;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();
  int maxHistoryLength = 50;

  Termite() {
    location = new PVector((int)random(width),(int)random(height));
    direction = pickRandomDirection();
  }

  public PVector pickRandomDirection() {
    int r = (int) random(4);
    switch(r){
      case 0:
        return new PVector(1,0);
      case 1:
        return new PVector(0,1);
      case 2:
        return new PVector(0,-1);
    }
    return new PVector(-1,0);
  }

  public void run() {
    update();
    // render();
  }

 
  // Method to update location
  public void update() {
    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);
    /*
    if (random(100)>33){
      nextPos.x += 1;
    }
    if (random(100)>33){
      nextPos.x -= 1;
    }
    if (random(100)>33){
      nextPos.y -= 1;
    }
    if (random(100)>33){
      nextPos.y += 1;
    }
    */

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

  }

  public Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }
  
  public Boolean dropFood(PVector location) {
    foodMap.stroke(0);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }

  public void render() {
    noSmooth();
    if(action){
      stroke(255,0,0);  
      strokeWeight(1); 
    } else {

      if(carriesFood){
        stroke(0); 
        strokeWeight(1);  
      } else {
        stroke(128); 
        strokeWeight(1);  
      } 
    }
    point(location.x, location.y);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "a_termites" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
