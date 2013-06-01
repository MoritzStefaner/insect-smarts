/* 
  
  I-N°S.E-C:T 
  S.M-A°R:T.S

  Moritz Stefaner (moritz@stefaner.eu), May 2013
  https://github.com/MoritzStefaner/insect-smarts

  based on http://natureofcode.com
 */

import eu.stefaner.insectsmarts.*;
import controlP5.*;
ControlP5 cp5;

Flock flock;

float MAX_FORCE  = .1;      // Maximum steering force
float MAX_SPEED  = 3;       // Maximum speed

int TRAIL_LENGTH = 100;     // length of "tails"
float NEIGHBOR_DIST = 50;   // distance at which two boids are considered neighbors
float SEPARATION = .5;      // strength of separation force
float ALIGNMENT  = .5;      // strength of alignment force
float COHESION   = .5;      // strength of cohesion force

int NUM_BOIDS = 100;        // number of boids

void setup() {
  ImageSaver.userName = "someone";

  size(1024,640, P2D);
  frameRate(30);
  colorMode(HSB, 1f);
  smooth(4);
  
  initControls();
  initSimulation();
}


void initSimulation(){
  flock = new Flock();
}

void draw() {
  background(.2, .1, .97);
  flock.run();
}

// Add a new boid into the System
void mouseDragged() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void save(){
  ImageSaver.save(this);
}

void post(){
  ImageSaver.saveAndPost(this);
}


void initControls(){
  cp5 = new ControlP5(this);

  int colWidth = 140;
  int textColWidth = 60;
  int x = width - colWidth - 10;
  int counter = 0;
  int rowHeight = 30;

  
  cp5.addButton("save",1,x,10,colWidth/2-5,20);
  cp5.addButton("post",1,x + colWidth/2 + 5,10,colWidth/2-5,20);
  
  counter++;
  cp5.addTextlabel("label").setText("MAX FORCE").setPosition(x, counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("MAX_FORCE",0,1,MAX_FORCE,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);

  counter++;
  cp5.addTextlabel("label" + counter).setText("MAX SPEED").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("MAX_SPEED",1,10,MAX_SPEED,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);

  counter++;
  cp5.addTextlabel("label" + counter).setText("TRAIL LENGTH").setPosition(x,106).setColor(color(0,0,.3));
  cp5.addSlider("TRAIL_LENGTH",0,400,TRAIL_LENGTH,x+textColWidth,100,colWidth-textColWidth,20);
  
  counter++;
  cp5.addTextlabel("label" + counter).setText("SEPARATION").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("SEPARATION",0,1,SEPARATION,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);

  counter++;
  cp5.addTextlabel("label" + counter).setText("COHESION").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("COHESION", 0,1,COHESION,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);

  counter++;
  cp5.addTextlabel("label" + counter).setText("ALIGNMENT").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("ALIGNMENT",0,1,ALIGNMENT,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);
  
  counter++;
  cp5.addTextlabel("label" + counter).setText("NUM BOIDS").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("NUM_BOIDS",1,200,NUM_BOIDS,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);

  counter++;
  cp5.addTextlabel("label" + counter).setText("NEIGHBOR_DIST").setPosition(x,counter*rowHeight + 16).setColor(color(0,0,.3));
  cp5.addSlider("NEIGHBOR_DIST",10,100,NEIGHBOR_DIST,x+textColWidth,counter*rowHeight + 10,colWidth-textColWidth,20);
}
