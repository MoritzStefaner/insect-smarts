/* 
  
  I-N°S.E-C:T 
  S.M-A°R:T.S

  Moritz Stefaner (moritz@stefaner.eu), May 2013
  https://github.com/MoritzStefaner/insect-smarts

  based on code from http://natureofcode.com

 */

import controlP5.*;
import eu.stefaner.insectsmarts.*;

Flock flock;
ControlP5 cp5;

int NUM_BOIDS = 300;
PImage antImage;

void setup() {
  
  
  ImageSaver.userName = "someone";
  initControls();

  antImage = loadImage("ant.png");

  imageMode(CENTER);
  blendMode(MULTIPLY);

  size(1024,720, P2D);
  frameRate(30);
  colorMode(HSB, 1f);
  smooth();

  initControllers();
  initSimulation();
}

void initControllers(){
 
}

void initSimulation(){
  flock = new Flock();
}

void draw() {

  background(.2, .1, .95, .5);
  flock.run();
  
  // Instructions
  fill(0);
  //text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  flock.addAnt(new Ant(mouseX,mouseY));
}

// ------------------------------------------------------

// set up buttons for parameter controls
void initControls(){
  cp5 = new ControlP5(this);
  cp5.addButton("save",1,10,10,30,20);
  cp5.addButton("post",1,10,35,30,20);
}

// save image
void save(){
  ImageSaver.save(this);
}

// save image and post to http://insect-smarts.tumblr.com
void post(){
  ImageSaver.saveAndPost(this);
}



