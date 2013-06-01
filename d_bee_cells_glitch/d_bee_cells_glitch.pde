import traer.physics.*;

ParticleSystem physics;
Particle centerParticle;
int NUM_RINGS = 10;
int NUM_SEGMENTS = 12;
ArrayList centers = new ArrayList();

void setup()
{
  size( 900, 600, P2D);
  smooth();
  fill( 0 );
  ellipseMode( CENTER );

  physics = new ParticleSystem( 0, 0.1 );
  
  for (int i=0; i<NUM_RINGS; i++) {
    makeRing();
  }

  Particle p1;
  Particle p2;
  
  for (int i=0; i<centers.size(); i++) {
    for (int j=i+1; j<centers.size(); j++) {
      p1 = (Particle) centers.get(i);
      p2 = (Particle) centers.get(j);
      // a, b, strength, minimumDistance
      physics.makeAttraction(p1, p2, 30, 10);
    }
  }
  for (int i=0; i<physics.numberOfParticles(); i++) {
    for (int j=i+1; j<physics.numberOfParticles(); j++) {
      p1 = physics.getParticle(i);
      p2 = physics.getParticle(j);
      // a, b, strength, minimumDistance
      physics.makeAttraction(p1, p2, -10, 10);
    }
  }
}

void mousePressed() {
}
void mouseDragged()
{
}

void mouseReleased()
{
}

void makeRing()
{
  Particle center  = physics.makeParticle(100.0, random(width), random(height), 0);
  centers.add(center);
  
  Particle firstParticle = null;
  Particle previousParticle = null;
  Particle p = null;
  
  for (int i=0; i<NUM_SEGMENTS; i++) {
    
    // mass, x, y, z
    p = physics.makeParticle(2.0, random(width), random(height), 0);
    if (i==0) {
      firstParticle = p;
    } 
    else {
      makeSpring( p, previousParticle);
    }
    physics.makeSpring( p, center, .1, 0.5, 50 );
    previousParticle = p;
  }
  makeSpring( p, firstParticle);
}

void makeSpring(Particle a, Particle b) {
  // strength, damping, restLength
  physics.makeSpring( a, b, 1, 0.5, 20 );
}


void draw()
{
  physics.tick();

  background( 0 );
  fill(200);
  stroke(200);
  
  Particle p;
  for (int i=0; i<centers.size(); i++) {
    p = (Particle)centers.get(i);
    float x = p.position().x();
    x += (width/2 - x)*.1;
    float y = p.position().y();
    y += (height/2 - y)*.1; 
    p.position().set(x,y,0);
  }
  
  

  for (int i=0; i<physics.numberOfParticles(); i++) {
    p = physics.getParticle(i);
    ellipse( p.position().x(), p.position().y(), 5, 5 );
  }
  

  Spring s;
  Particle p1;
  Particle p2;
  for (int i=0; i<physics.numberOfSprings(); i++) {
    s = physics.getSpring(i);
    p1 = s.getOneEnd();
    p2 = s.getTheOtherEnd();
    line( p1.position().x(), p1.position().y(), p2.position().x(), p2.position().y() );
  }

  // line( p.position().x(), p.position().y(), anchor.position().x(), anchor.position().y() );
}

