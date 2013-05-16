import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import eu.stefaner.insectsmarts.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class a_termites extends PApplet {



// Termites clean up my living roon

ArrayList<Termite> termites;
PGraphics foodMap;
PImage foodMapImage;

int MAP_WIDTH = 100;
int MAP_HEIGHT = 100;
int SCALE = 1;



public void setup() {
  ImageSaver.userName = "mo";
    
  size(MAP_WIDTH*SCALE,MAP_HEIGHT*SCALE);

  frameRate(50);

  int NUM_TERMITES = width*height/10;
  //NUM_TERMITES = 1;
  
  termites = new ArrayList<Termite>();
  // Add an initial set of termites into the system
  for (int i = 0; i < NUM_TERMITES; i++) {
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
  
  int total = 0;
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(random(100)>70){
        foodMap.point(i,j);
        total++;
      }
  }  
  println("total " + total);
  foodMap.endDraw();
  }
}

public void draw() {
  
  background(255);
  scale(SCALE);
  noSmooth();
  
  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);

  for (Termite t : termites) {
      t.update(); 
  }
  
  foodMap.endDraw();
  image(foodMap, 0, 0);
    
  for (Termite t : termites) {
      t.draw(); 
  }
}

public void keyPressed(){
  ImageSaver.saveAndPost(this);
}



class Termite {

  PVector location;
  PVector direction;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();

  Termite() {
    location = new PVector((int) random(width),(int) random(height));
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
  }

 
  // Method to update location
  public void update() {
    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);

    nextPos.x = (nextPos.x + width) % width;
    nextPos.y = (nextPos.y + height) % height;

    int col = foodMap.get((int) nextPos.x, (int) nextPos.y);

    if(brightness(col) < 255){
        if(carriesFood){
          // try to drop food
          carriesFood = !dropFood(location);
        } else {
          // pick up food
          carriesFood = pickUpFood(nextPos);
        }
        action = true;
        direction = pickRandomDirection();
    } else{
      action = false;
      location = nextPos;  
    }

  }

  public Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }
  
  public Boolean dropFood(PVector location) {
    int col = foodMap.get((int) location.x, (int) location.y);
    if(brightness(col) < 255){
      // there is food already here!
      return false; 
    } else {
      foodMap.stroke(0);
      foodMap.strokeWeight(1);
      foodMap.point((int) location.x, (int) location.y);
      return true;  
    }
    
  }

  public void draw() {
    strokeWeight(1); 
    if(action){
      stroke(255,128,0);  
    } else {
      if(carriesFood){
        stroke(100); 
      } else {
        stroke(200); 
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
