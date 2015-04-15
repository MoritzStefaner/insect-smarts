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

ArrayList<Ant> ants;
PGraphics foodMap;
PGraphics pheroMap;
PImage pheromapImage;

void setup() {
  size(700, 700, P2D);
  frameRate(30);

  ImageSaver.userName = "someone";
  initControls();

  // image to draw pheromone trails with
  pheromapImage = loadImage("texture.png");

  // create extra graphics object to store pheromone trails
  pheroMap = createGraphics(width, height);
  pheroMap.imageMode(CENTER);
  pheroMap.beginDraw();
  pheroMap.background(255);
  pheroMap.endDraw();

  // create extra graphics object to store food
  foodMap = createGraphics(width, height);
  foodMap.beginDraw();
  foodMap.background(255);
  foodMap.smooth(4);

  float foodProbability = .25;
  for (int i=0; i < width; i++) {
    for (int j=0; j < height; j++) {
      float randomValue = noise(i*.01, j*.01);
      if (randomValue < foodProbability) {
        foodMap.stroke(5 * int(randomValue * 10));
        foodMap.point(i, j);
      }
    }
    foodMap.endDraw();
  }

  ants = new ArrayList<Ant>();
  // Add an initial set of ants into the system
  for (int i = 0; i < width*height/500; i++) {
    Ant t = new Ant();
    ants.add(t);
  }
}

// draw a trail
void mousePressed() {
  pheroMap.tint(255);
  pheroMap.image(pheromapImage, mouseX, mouseY);
}

// draw a trail
void mouseDragged() {
  pheroMap.tint(255);
  pheroMap.image(pheromapImage, mouseX, mouseY);
}

void draw() {
  blendMode(NORMAL);
  background(255, 255, 255);

  blendMode(MULTIPLY);
  image(foodMap, 0, 0);

  //tint(255, 0, 100, 10);
  image(pheroMap, 0, 0);

  pheroMap.beginDraw();

  // fade out pheroMap
  pheroMap.fill(255, 255, 255, 3);
  pheroMap.rect(0, 0, width, height);

  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);

  for (Ant t : ants) {
    t.run();
  }

  foodMap.endDraw();
  pheroMap.endDraw();

  stroke(0);
  strokeWeight(10);
  point(width/2, height/2);
}

// -------------------------------------------------------------

// set up buttons for parameter controls
void initControls() {
  cp5 = new ControlP5(this);
  cp5.addButton("save", 1, width - 35, 10, 30, 20);
  cp5.addButton("post", 1, height - 35, 35, 30, 20);
}

// save image
void save() {
  ImageSaver.save(this);
}

// save image and post to http://insect-smarts.tumblr.com
void post() {
  ImageSaver.saveAndPost(this);
}
