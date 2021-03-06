/*

 I-N°S.E-C:T
 S.M-A°R:T.S
 
 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts
 
 */

import eu.stefaner.insectsmarts.*;
import controlP5.*;
ControlP5 cp5;

Flock flock;

float MAX_FORCE  = .1;      // Maximum steering force
float MAX_SPEED  = 3;       // Maximum speed

int TRAIL_LENGTH = 40;     // length of "tails"
float NEIGHBOR_DIST = 50;   // distance at which two boids are considered neighbors
float SEPARATION = .5;      // strength of separation force
float ALIGNMENT  = .5;      // strength of alignment force
float COHESION   = .5;      // strength of cohesion force

int NUM_BOIDS = 500;        // number of boids

void setup() {
  ImageSaver.userName = "someone";

  size(1920, 1080, P2D);
  frameRate(30);
  colorMode(HSB, 1f);

  initControls();
  initSimulation();
}


void initSimulation() {
  flock = new Flock();
}

int COUNT = 0;
void draw() {
  COUNT++;
//  MAX_SPEED = 3+2*(sin(COUNT*.007)+1)/2;
//  COHESION = (sin(COUNT*.01)+1)/2;
//  SEPARATION = (cos(2*COUNT*.01)+1)/2;
//  ALIGNMENT = (sin(3*COUNT*.01)+1)/2;
//  NEIGHBOR_DIST = 100 + 50*(sin(3*COUNT*.01));
  fill(1,0,1,10/255f);
  rect(0,0,width,height);
  //background(1, 0, 1);
  flock.run();
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX, mouseY));
}

void save() {
  ImageSaver.save(this);
}

void post() {
  ImageSaver.saveAndPost(this);
}


void initControls() {
  cp5 = new ControlP5(this);

  int colWidth = 140;
  int textColWidth = 75;
  int x = width - colWidth - 10;
  int counter = 0;
  int rowHeight = 30;

  cp5.addButton("save", 1, x, 10, colWidth/2-5, 20);
  cp5.addButton("post", 1, x + colWidth/2 + 5, 10, colWidth/2-5, 20);

  cp5.addSlider("MAX_FORCE")
    .setRange(0, 1)
      .setValue(MAX_FORCE)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("MAX_SPEED")
    .setRange(1, 10)
      .setValue(MAX_SPEED)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("TRAIL_LENGTH")
    .setRange(0, 400)
      .setValue(TRAIL_LENGTH)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("SEPARATION")
    .setRange(0, 1)
      .setValue(SEPARATION)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("COHESION")
    .setRange(0, 1)
      .setValue(COHESION)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("ALIGNMENT")
    .setRange(0, 1)
      .setValue(ALIGNMENT)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("NUM_BOIDS")
    .setRange(10, 2000)
      .setValue(NUM_BOIDS)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));

  cp5.addSlider("NEIGHBOR_DIST")
    .setRange(10, 100)
      .setValue(NEIGHBOR_DIST)
        .setPosition(x, (++counter)*rowHeight + 10)
          .setSize(colWidth-textColWidth, 20)
            .setColorLabel(color(.2));
}

