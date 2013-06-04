/* 
 
 I-N°S.E-C:T 
 S.M-A°R:T.S
 
 Moritz Stefaner (moritz@stefaner.eu), May 2013
 https://github.com/MoritzStefaner/insect-smarts
 
 */

import controlP5.*;
import eu.stefaner.insectsmarts.*;

ControlP5 cp5;

ArrayList<Neuron> neurons = new ArrayList<Neuron>();
ArrayList<Axon> axons = new ArrayList<Axon>();

int NUM_NEURONS = 100;

void setup() {
  ImageSaver.userName = "someone";

  size(1024, 720, P2D);
  frameRate(20);
  colorMode(HSB, 1f);
  smooth();
  initControls();

  for (int i = 0; i < NUM_NEURONS; i++) {
    neurons.add(new Neuron());
  }

  for (int i = 0; i < NUM_NEURONS; i++) {
  	for (int j = 0; j < NUM_NEURONS; j++) {
  		Neuron n1 = neurons.get(i);
  		Neuron n2 = neurons.get(j);
  		float dist = new PVector((n1.x-n2.x), (n1.y-n2.y)).mag();
  		if(i!=j && dist<100){
  			Axon a = new Axon(n1, n2);
  			axons.add(a);
  			n1.outgoingAxons.add(a);
  		}
  	}
  }
}

void draw() {
  // clear screen
  background(0,0,0);

  for (Neuron n : neurons) {
    n.run();
  }

  for (Axon a : axons) {
    a.run();
  }
}


// set up buttons for parameter controls
void initControls() {
  cp5 = new ControlP5(this);

  int colWidth = 200;
  int textColWidth = 50;
  int counter = 0;
  int rowHeight = 30;
  int x = width - colWidth - 10;

  cp5.addButton("save", 1, x, 10, (colWidth-textColWidth)/2-5, 20);
  cp5.addButton("post", 1, x + (colWidth-textColWidth)/2 + 5, 10, (colWidth-textColWidth)/2-5, 20);

  cp5.addSlider("DECAY")
    .setRange(0, .1)
    .setValue(DECAY)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.8));

  cp5.addSlider("RANDOM_FIRE")
    .setRange(0, 1)
    .setValue(DECAY)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.8));

  cp5.addSlider("AXON_SPEED")
    .setRange(.0001, .001)
    .setValue(AXON_SPEED)
    .setPosition(x, (++counter)*rowHeight + 10)
    .setSize(colWidth-textColWidth, 20)
    .setColorLabel(color(.8));
}


// save image
void save() {
  ImageSaver.save(this);
}

// save image and post to http://insect-smarts.tumblr.com
void post() {
  ImageSaver.saveAndPost(this);
}