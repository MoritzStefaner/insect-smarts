/* 
  
  I-N°S.E-C:T 
  S.M-A°R:T.S

  Moritz Stefaner (moritz@stefaner.eu), May 2013
  https://github.com/MoritzStefaner/insect-smarts

  based on http://natureofcode.com

 */

import eu.stefaner.insectsmarts.*;
import controlP5.*;
import traer.physics.*;

ControlP5 cp5;

ParticleSystem physics;

int NUM_PARTICLES = 400;
PImage blurredCircle;

Particle mouseParticle;

void setup()
{
  ImageSaver.userName = "someone";
  initControls();

  blurredCircle = loadImage("texture.png");

  size(600, 600, P2D);
  smooth();
  fill( 0 );
  imageMode( CENTER );

  physics = new ParticleSystem( 0, 0.2);
  
  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeParticle(100.0, random(width), random(height), 0);
  }

  mouseParticle = physics.makeParticle(100.0, 0, 0, 0);

  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeAttraction(mouseParticle, physics.getParticle(i), -1, 10);  
    for (int j=0; j<NUM_PARTICLES; j++) {
      if(i!=j){
        physics.makeAttraction(physics.getParticle(i), physics.getParticle(j), -.1, 10);  
      }
    }
  }
}

void mousePressed() {

}

void mouseDragged() {
}

void mouseReleased() {
}


void makeSpring(Particle a, Particle b) {
  // strength, damping, restLength
  physics.makeSpring( a, b, .5, 0.5, 50 );
}

float counter=0;

void draw()
{
  physics.tick();
  blendMode(LIGHTEST);

  background( 0 );
  fill(200);
  stroke(200);
  
  if(counter<200) counter+=.1;

  mouseParticle.position().set((float)mouseX, (float)mouseY,0);
  
  Particle p;
  for (int i=0; i<physics.numberOfParticles(); i++) {
    p = physics.getParticle(i);
    float x = p.position().x();
    float y = p.position().y();
    PVector toCenter = new PVector();

    toCenter.x = width/2 - x;
    toCenter.y = height/2 - y;
    float dist = toCenter.mag();
    toCenter.normalize();
    toCenter.mult(Math.min(dist, counter * dist * .0005));
    p.position().add(toCenter.x , toCenter.y ,0);
  }

  for (int i=0; i<physics.numberOfParticles(); i++) {
    p = physics.getParticle(i);
    //ellipse( p.position().x(), p.position().y(), 5, 5 );
    image(blurredCircle, p.position().x(), p.position().y());
  }

}

void initControls(){
  cp5 = new ControlP5(this);
  cp5.addButton("save", 1, width - 35, 10, 30, 20);
  cp5.addButton("post", 1, width - 35, 35, 30, 20);
}

void save(){
  ImageSaver.save(this);
}

void post(){
  ImageSaver.saveAndPost(this);
}
