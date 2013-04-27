import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import traer.physics.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class d_bee_cells extends PApplet {



ParticleSystem physics;

int NUM_PARTICLES = 400;
PImage blurredCircle;

public void setup()
{
  
  blurredCircle = loadImage("texture.png");

  size( 1024, 768, P2D);
  smooth();
  fill( 0 );
  imageMode( CENTER );

  physics = new ParticleSystem( 0, 0.2f);
  
  for (int i=0; i<NUM_PARTICLES; i++) {
    physics.makeParticle(100.0f, random(width), random(height), 0);
  }

  for (int i=0; i<NUM_PARTICLES; i++) {
    for (int j=0; j<NUM_PARTICLES; j++) {
      if(i!=j){
        physics.makeAttraction(physics.getParticle(i), physics.getParticle(j), -.1f, 10);  
      }
      
    }
  }
}

public void mousePressed() {

}

public void mouseDragged() {
}

public void mouseReleased() {
}


public void makeSpring(Particle a, Particle b) {
  // strength, damping, restLength
  physics.makeSpring( a, b, .5f, 0.5f, 50 );
}

float counter=0;

public void draw()
{
  physics.tick();
  blendMode(LIGHTEST);

  background( 0 );
  fill(200);
  stroke(200);
  
  if(counter<200) counter+=.1f;
  
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
    toCenter.mult(Math.min(dist, counter * dist * .0005f));
    p.position().add(toCenter.x , toCenter.y ,0);
  }

  for (int i=0; i<physics.numberOfParticles(); i++) {
    p = physics.getParticle(i);
    //ellipse( p.position().x(), p.position().y(), 5, 5 );
    image(blurredCircle, p.position().x(), p.position().y());
  }

}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "d_bee_cells" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
