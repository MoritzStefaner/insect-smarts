/* 
 
 I-N°S.E-C:T 
 S.M-A°R:T.S
 
 Moritz Stefaner (moritz@stefaner.eu), May 2013
 https://github.com/MoritzStefaner/insect-smarts
 
 based on code from http://natureofcode.com
 
 */

import controlP5.*;
import eu.stefaner.insectsmarts.*;

ControlP5 cp5;

int NUM_ANTS = 250;
int NEIGHBOR_DIST = 30;
boolean TRAILS = false;

PImage antImage;
ArrayList<Ant> ants = new ArrayList<Ant>(); // An ArrayList for all the ants

void setup() {
  ImageSaver.userName = "someone";

  size(1024, 720, P2D);
  frameRate(20);
  colorMode(HSB, 1f);
  smooth();
  initControls();

  antImage = loadImage("ant.png");
  imageMode(CENTER);

  background(.2, .1, .95);
}

void draw() {

  if(TRAILS){
    // clear screen, but leave traces from last time
    fill(.2, .1, .95, .02);
    rect(0,0,width, height);
  } else {
    // clear screen
    background(.2, .1, .95);
  }
  
  while (ants.size()<NUM_ANTS){
    ants.add(new Ant(random(width),random(height)));
  }

  while (ants.size()>NUM_ANTS){
    ants.remove(0);
  } 

  for (Ant b : ants) {
    b.run(ants);  // Passing the entire list of ants to each boid individually
  }
}

// Add a new boid into the System
void mouseDragged() {
  ants.add(new Ant(mouseX, mouseY));
}


// ------------------------------------------------------

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

  cp5.addSlider("NEIGHBOR_DIST")
    .setRange(0, 100)
    .setValue(NEIGHBOR_DIST)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.2));

  cp5.addSlider("NUM_ANTS")
    .setRange(10, 300)
    .setValue(NUM_ANTS)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.2));

  cp5.addSlider("MAX_FORCE")
    .setRange(0, 20)
    .setValue(MAX_FORCE)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.2));

  cp5.addSlider("LOOK_ANGLE")
    .setRange(0, .5)
    .setValue(LOOK_ANGLE)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.2));

  cp5.addToggle("TRAILS")
     .setPosition(x,(++counter)*rowHeight + 16)
     .setSize(20,20)
     .setValue(TRAILS)
     .setColorLabel(color(.2))
    ;
}

// save image
void save() {
  ImageSaver.save(this);
}

// save image and post to http://insect-smarts.tumblr.com
void post() {
  ImageSaver.saveAndPost(this);
}