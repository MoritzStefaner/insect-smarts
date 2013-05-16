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

float MAX_FORCE  = .1;    // Maximum steering force
float MAX_SPEED  = 3;    // Maximum speed

int TRAIL_LENGTH = 100;
float SEPARATION = .5;
float ALIGNMENT  = .5;
float COHESION   = .5;    

int NUM_BOIDS = 100;

void setup() {
  ImageSaver.userName = "someone";
  size(1280,720, P2D);
  frameRate(30);
  colorMode(HSB, 1f);
  smooth();

  initControllers();
  initSimulation();
}

void initControllers(){
  cp5 = new ControlP5(this);

  int colWidth = 140;
  int textColWidth = 60;
  int x = width - colWidth - 10;

  cp5.addButton("saveAndPost",1,x,10,colWidth,20);

  cp5.addTextlabel("label").setText("MAX FORCE").setPosition(x,46).setColor(color(0,0,.3));
  cp5.addSlider("MAX_FORCE",0,1,MAX_FORCE,x+textColWidth,40,colWidth-textColWidth,20);

  cp5.addTextlabel("label1").setText("MAX SPEED").setPosition(x,76).setColor(color(0,0,.3));
  cp5.addSlider("MAX_SPEED",1,10,MAX_SPEED,x+textColWidth,70,colWidth-textColWidth,20);

  cp5.addTextlabel("label2").setText("TRAIL LENGTH").setPosition(x,106).setColor(color(0,0,.3));
  cp5.addSlider("TRAIL_LENGTH",0,400,TRAIL_LENGTH,x+textColWidth,100,colWidth-textColWidth,20);

  cp5.addTextlabel("label3").setText("SEPARATION").setPosition(x,136).setColor(color(0,0,.3));
  cp5.addSlider("SEPARATION",0,1,SEPARATION,x+textColWidth,130,colWidth-textColWidth,20);

  cp5.addTextlabel("label4").setText("COHESION").setPosition(x,166).setColor(color(0,0,.3));
  cp5.addSlider("COHESION", 0,1,COHESION,x+textColWidth,160,colWidth-textColWidth,20);

  cp5.addTextlabel("label5").setText("ALIGNMENT").setPosition(x,196).setColor(color(0,0,.3));
  cp5.addSlider("ALIGNMENT",0,1,ALIGNMENT,x+textColWidth,190,colWidth-textColWidth,20);
  
 cp5.addTextlabel("label6").setText("NUM BOIDS").setPosition(x,226).setColor(color(0,0,.3));
  cp5.addSlider("NUM_BOIDS",1,200,NUM_BOIDS,x+textColWidth,220,colWidth-textColWidth,20);
}

void initSimulation(){
  flock = new Flock();
}

void draw() {

  background(.2, .1, .97);
  flock.run();
  
    // Instructions
  fill(0);
  //text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
void mouseDragged() {
  // flock.addBoid(new Boid(mouseX,mouseY));
}

void saveAndPost(){
  ImageSaver.saveAndPost(this);
}


