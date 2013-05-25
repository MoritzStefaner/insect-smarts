
// a_emergence

// author: Moritz Stefaner
// for insect smarts workshop
// May 2013

// see

import controlP5.*;
import eu.stefaner.insectsmarts.*;
ControlP5 cp5;

float x = 0;
float y = 0;

PGraphics result;
PVector wayHome;

void setup(){
	
	ImageSaver.userName = "someone";
	initControls();

	size(300,300, P2D);
	background(0);
	frameRate(500);
	smooth();

	result = createGraphics(width, height);
	result.beginDraw();
	result.smooth();
	result.stroke(255);
	result.strokeWeight(10);
	result.point(width/2, height/2);
	result.endDraw();

	chooseNewPosition();
}

void draw(){
	
	float newX, newY;

	// steady movement
	newX = x + wayHome.x;
	newY = y + wayHome.y;

	// decelerate at center
	// newX = x + (width/2 - x) * .1;
	// newY = y + (height/2 - y) * .1;

	// Test: have we hit the structure?
	color pixel = result.get((int) newX, (int) newY);
	
	if(brightness(pixel)>0){
		// yes
		// draw a new part where we hit it
		result.beginDraw();
		result.stroke(255);
		result.smooth();
		result.strokeWeight(6);
		result.point((int) x, (int) y);
		result.endDraw();

		// move forward
		chooseNewPosition();
	} else {
		// move forward
		x = newX;
		y = newY;	
	}

	// draw the structure
	background(0);
	image(result, 0,0);

	// draw the particle
	stroke(255);
	strokeWeight(2);
	point((int) x, (int) y);
}

void chooseNewPosition(){
	// start on circle around center, at a random angle
	float angle = random(2*PI);
	x = width/2 + cos(angle) * width/2;
	y = height/2 + sin(angle) * height/2;
	
	// wayHome is a vector pointing home, with a fixed magnitude
	wayHome = new PVector(width/2-x, height/2-y);
	wayHome.setMag(6);	
}

void initControls(){
	cp5 = new ControlP5(this);
	cp5.addButton("save",1,10,10,30,20);
	cp5.addButton("post",1,10,35,30,20);
}

void save(){
  ImageSaver.save(this);
}

void post(){
  ImageSaver.saveAndPost(this);
}
