import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class boids extends PApplet {




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
ControlP5 cp5;

float MAX_FORCE  = .1f;    // Maximum steering force
float MAX_SPEED  = 3;    // Maximum speed

int TRAIL_LENGTH = 100;
float SEPARATION = .5f;
float ALIGNMENT  = .5f;
float COHESION   = .5f;    

int NUM_BOIDS = 100;

public void setup() {
  size(1280,720, P2D);
  frameRate(30);
  colorMode(HSB, 1f);
  smooth();

  initControllers();
  initSimulation();
}

public void initControllers(){
  cp5 = new ControlP5(this);

  int colWidth = 140;
  int textColWidth = 60;
  int x = width - colWidth - 10;

  cp5.addButton("save pdf",1,x,10,colWidth,20);
  cp5.addTextlabel("label").setText("MAX FORCE").setPosition(x,46).setColor(color(0,0,.3f));
  cp5.addSlider("MAX_FORCE",0,1,MAX_FORCE,x+textColWidth,40,colWidth-textColWidth,20);

  cp5.addTextlabel("label1").setText("MAX SPEED").setPosition(x,76).setColor(color(0,0,.3f));
  cp5.addSlider("MAX_SPEED",1,10,MAX_SPEED,x+textColWidth,70,colWidth-textColWidth,20);

  cp5.addTextlabel("label2").setText("TRAIL LENGTH").setPosition(x,106).setColor(color(0,0,.3f));
  cp5.addSlider("TRAIL_LENGTH",0,400,TRAIL_LENGTH,x+textColWidth,100,colWidth-textColWidth,20);

  cp5.addTextlabel("label3").setText("SEPARATION").setPosition(x,136).setColor(color(0,0,.3f));
  cp5.addSlider("SEPARATION",0,1,SEPARATION,x+textColWidth,130,colWidth-textColWidth,20);

  cp5.addTextlabel("label4").setText("COHESION").setPosition(x,166).setColor(color(0,0,.3f));
  cp5.addSlider("COHESION", 0,1,COHESION,x+textColWidth,160,colWidth-textColWidth,20);

  cp5.addTextlabel("label5").setText("ALIGNMENT").setPosition(x,196).setColor(color(0,0,.3f));
  cp5.addSlider("ALIGNMENT",0,1,ALIGNMENT,x+textColWidth,190,colWidth-textColWidth,20);
  
 cp5.addTextlabel("label6").setText("NUM BOIDS").setPosition(x,226).setColor(color(0,0,.3f));
  cp5.addSlider("NUM_BOIDS",1,200,NUM_BOIDS,x+textColWidth,220,colWidth-textColWidth,20);
}

public void initSimulation(){
  flock = new Flock();
}

public void draw() {

  background(.2f, .1f, .97f);
  flock.run();
  
    // Instructions
  fill(0);
  //text("Drag the mouse to generate new boids.",10,height-16);
}

// Add a new boid into the System
public void mouseDragged() {
  // flock.addBoid(new Boid(mouseX,mouseY));
}


// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  
  ArrayList<PVector> history = new ArrayList<PVector>();
  

  Boid(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-1,1),random(-1,1));
    location = new PVector(x,y);
    r = 2.0f;
    
    MAX_FORCE = .1f;
  }

  public void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  public void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(SEPARATION);
    ali.mult(ALIGNMENT);
    coh.mult(COHESION);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  public void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(MAX_SPEED);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);

    history.add(new PVector(location.x, location.y));
    while(history.size() > TRAIL_LENGTH){
      history.remove(0);
    }
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  public PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(MAX_SPEED);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(MAX_FORCE);  // Limit to maximum steering force
    return steer;
  }
  
  public void render() {
    // draw history
    PVector lastLoc = location;
    float decay;
    for (int i=history.size()-1; i>=0; i--){
      PVector p = history.get(i);
      decay = PApplet.parseFloat(i)/TRAIL_LENGTH;
      if(Math.abs(lastLoc.x-p.x)<=width-20 && Math.abs(lastLoc.y-p.y)<=height-20) {
        stroke(.2f+decay*.5f, .8f, .5f, decay/2);
        strokeWeight(2 * decay);
        line(lastLoc.x, lastLoc.y, p.x, p.y);  
      }
      lastLoc = p;
    }

    r = 2*velocity.mag()/MAX_SPEED;

    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(0, 120);
    noStroke();
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    translate(0,-3*r);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();

    
  }

  // Wraparound
  public void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  public PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location,other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location,other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(MAX_SPEED);
      steer.sub(velocity);
      steer.limit(MAX_FORCE);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  public PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(MAX_SPEED);
      PVector steer = PVector.sub(sum,velocity);
      steer.limit(MAX_FORCE);
      return steer;
    } else {
      return new PVector(0,0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  public PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location,other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(0,0);
    }
  }
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  public void run() {
    while (boids.size()<NUM_BOIDS)
      addBoid(new Boid(random(width),random(height)));

    while (boids.size()>NUM_BOIDS)
      boids.remove(0);

    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  public void addBoid(Boid b) {
    boids.add(b);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "boids" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
