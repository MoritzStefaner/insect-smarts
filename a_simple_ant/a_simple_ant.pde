/*

 I-N°S.E-C:T
 S.M-A°R:T.S

 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts

 based on code from http://natureofcode.com

 */

SimpleAnt a1,a2;

PImage antImage;

void setup() {

  size(1024, 720, P2D);
  frameRate(20);
  colorMode(HSB, 1f);
  smooth();

  antImage = loadImage("ant.png");
  imageMode(CENTER);

  a1 = new SimpleAnt(random(width),random(height));
  a2 = new SimpleAnt(random(width),random(height));
  
  background(.2, .1, .95);
}

void draw() {
  background(.2, .1, .95);
  
  a1.run();
  a2.run();
}

