/*

 I-N°S.E-C:T
 S.M-A°R:T.S

 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts

*/
import eu.stefaner.insectsmarts.*;
import controlP5.*;
import traer.physics.*;

ControlP5 cp5;

ParticleSystem physics;

int NUM_PARTICLES = 500;
float STRENGTH = 1;

PImage blurredCircle;
Particle mouseParticle;

void setup() {
  ImageSaver.userName = "someone";

  size(600, 600, P2D);
  initControls();

  blurredCircle = loadImage("texture.png");

  physics = new ParticleSystem( 0, 0.2);

  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeParticle(100.0, random(width), random(height), 0);
  }

  mouseParticle = physics.makeParticle(100.0, 0, 0, 0);

  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeAttraction(mouseParticle, physics.getParticle(i), -1, 10);
    for (int j=0; j<NUM_PARTICLES; j++) {
      if (i!=j) {
        physics.makeAttraction(physics.getParticle(i), physics.getParticle(j), -.1, 10);
      }
    }
  }
}


void makeSpring(Particle a, Particle b) {
  // strength, damping, restLength
  physics.makeSpring( a, b, .5, 0.5, 50 );
}

void draw() {
  physics.tick();
  imageMode( CENTER );

  blendMode(LIGHTEST);

  background(0);

  //if (STRENGTH<200) STRENGTH+=.1;

  mouseParticle.position().set((float)mouseX, (float)mouseY, 0);

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
    toCenter.mult(Math.min(dist, STRENGTH * dist * .0005));
    p.position().add(toCenter.x, toCenter.y, 0);
  }

  for (int i=0; i<physics.numberOfParticles(); i++) {
    p = physics.getParticle(i);
    image(blurredCircle, p.position().x(), p.position().y());
  }
  blendMode(NORMAL);
}

// --------------------------------------------------------------

void initControls() {
  cp5 = new ControlP5(this);
  cp5.addButton("save", 1, width - 105, 15, 45, 20);
  cp5.addButton("post", 1, width - 55, 15, 45, 20);
  cp5.addSlider("STRENGTH", 1, 200, STRENGTH, width - 105, 45, 45, 20);
}

void save() {
  ImageSaver.save(this);
}

void post() {
  ImageSaver.saveAndPost(this);
}
