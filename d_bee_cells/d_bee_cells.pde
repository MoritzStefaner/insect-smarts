import traer.physics.*;

ParticleSystem physics;

int NUM_PARTICLES = 400;
PImage blurredCircle;

void setup()
{
  
  blurredCircle = loadImage("texture.png");

  size( 1024, 768, P2D);
  smooth();
  fill( 0 );
  imageMode( CENTER );

  physics = new ParticleSystem( 0, 0.2);
  
  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeParticle(100.0, random(width), random(height), 0);
  }

  for (int i=0; i<NUM_PARTICLES; i++) {
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

