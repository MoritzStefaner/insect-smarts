/* 
 
 I-N°S.E-C:T 
 S.M-A°R:T.S
 
 Moritz Stefaner (moritz@stefaner.eu), May 2013
 https://github.com/MoritzStefaner/insect-smarts
 
 */

import controlP5.*;
import eu.stefaner.insectsmarts.*;
ControlP5 cp5;

ArrayList<Termite> termites;
PGraphics woodMap;
PImage woodMapImage;

// number of "fields" in each direction
int MAP_WIDTH = 100;
int MAP_HEIGHT = 100;

// scaling factor for drawing
int SCALE = 3;

void setup() {

  // enter your name here, will show up on tumblr if you press post
  ImageSaver.userName = "someone";

  initControls();
  size(MAP_WIDTH*SCALE, MAP_HEIGHT*SCALE);
  frameRate(200);

  // Add an initial set of termites into the system
  int NUM_TERMITES = MAP_WIDTH*MAP_HEIGHT/20;
  termites = new ArrayList<Termite>();
  for (int i = 0; i < NUM_TERMITES; i++) {
    termites.add(new Termite());
  }

  // create an image to store where the wood pieces lie
  woodMap = createGraphics(MAP_WIDTH, MAP_HEIGHT);
  woodMap.beginDraw();
  woodMap.background(255);
  woodMap.noFill();
  woodMap.noSmooth();
  woodMap.strokeWeight(1);
  woodMap.stroke(0);

  // initalize wood map
  float woodProbability = .4;
  for (int i=0; i<MAP_WIDTH; i++) {
    for (int j=0; j<MAP_HEIGHT; j++) {
      if (random(1)<woodProbability) {
        woodMap.point(i, j);
      }
    }  
    woodMap.endDraw();
  }
}

void draw() {
  background(255);
  
  pushMatrix();
  scale(SCALE);
  noSmooth();

  woodMap.beginDraw();
  woodMap.noFill();
  woodMap.noSmooth();
  woodMap.strokeWeight(1);

  // update the termites
  for (Termite t : termites) {
    t.update();
  }

  woodMap.endDraw();
  image(woodMap, 0, 0);

  for (Termite t : termites) {
    t.draw();
  }
  popMatrix();
}

// ------------------------------------------------------

// set up buttons for parameter controls
void initControls() {
  cp5 = new ControlP5(this);
  cp5.addButton("save", 1, MAP_WIDTH*SCALE - 35, 10, 30, 20);
  cp5.addButton("post", 1, MAP_WIDTH*SCALE - 35, 35, 30, 20);
}

// save image
void save() {
  ImageSaver.save(this);
}

// save image and post to http://insect-smarts.tumblr.com
void post() {
  ImageSaver.saveAndPost(this);
}

