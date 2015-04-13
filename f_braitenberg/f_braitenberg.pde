/*

 I-N°S.E-C:T
 S.M-A°R:T.S
 
 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts
 
 based on code from http://natureofcode.com
 
 */

import controlP5.*;
import eu.stefaner.insectsmarts.*;

Vehicle v = new Vehicle();

ControlP5 cp5;

int LIGHT_RADIUS = 350;

PImage vehicleImage;
ArrayList<PVector> lights = new ArrayList<PVector>();
ArrayList<PVector> trail = new ArrayList<PVector>();

Boolean hasToSave = false;
Boolean hasToPost = false;

void setup() {
  ImageSaver.userName = "Dominikus";

  size(1024, 720);
  frameRate(20);
  smooth();

  vehicleImage = loadImage("triangle.png");
  imageMode(CENTER);
  
  initControls();
}

// set up buttons for parameter controls
void initControls() {
  cp5 = new ControlP5(this);

  int colWidth = 200;
  int textColWidth = 90;
  int counter = 0;
  int rowHeight = 30;
  int x = width - colWidth - 10;

  cp5.addButton("save", 1, x, 10, (colWidth-textColWidth)/2-5, 20);
  cp5.addButton("post", 1, x + (colWidth-textColWidth)/2 + 5, 10, (colWidth-textColWidth)/2-5, 20);
}

void draw() {
  background(0);

  noStroke();
  fill(255, 128);
  // draw lights
  for (PVector l : lights) {
    drawGradient(l.x, l.y);
  }

  v.update();

  // draw the vehicle
  v.render();
  
  // store the trail
  trail.add(new PVector(v.location.x, v.location.y));
  
  // draw its trail
  noFill();
  stroke(255, 0, 0, 128);
  for (int i = 1; i < trail.size(); i++){
    line(trail.get(i-1).x, trail.get(i-1).y, trail.get(i).x, trail.get(i).y);
  }
  
  // save or post?
  if(hasToSave){
    noLoop();
    saveImage();
  }
  if(hasToPost){
    noLoop();
    postImage();
  }
}

void drawGradient(float x, float y) {
  int radius = LIGHT_RADIUS;
  for (int r = radius; r > 0; r -= 50) {
    fill(255, 128 - (r/15));
    ellipse(x, y, r, r);
  }
}

void mousePressed() {
  lights.add(new PVector(mouseX, mouseY, 0));
}

// save image
void save() {
  hasToSave = true;
}

void saveImage(){
  hasToSave = false;
  ImageSaver.save(this);
  loop();
}

// save image and post to http://insect-smarts.tumblr.com
void post() {
  hasToPost = true;
}

void postImage(){
  hasToPost = false;
  ImageSaver.saveAndPost(this);
  loop();
}
