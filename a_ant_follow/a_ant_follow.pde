import controlP5.*;
import eu.stefaner.insectsmarts.*;

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
ControlP5 cp5;

int NUM_BOIDS = 300;
PImage antImage;

void setup() {
  
  ImageSaver.userName = "someone";
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
  // flock.addBoid(new Boid(mouseX,mouseY));
}

void keyPressed(){
  ImageSaver.saveAndPost(this);
}


