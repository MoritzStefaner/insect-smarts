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

public class a_ant_follow extends PApplet {




// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

Flock flock;
ControlP5 cp5;

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
 
}

public void initSimulation(){
  flock = new Flock();
}

public void draw() {

  background(.2f, .1f, .95f, .5f);
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

float MAX_FORCE = 10;

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float MAX_SPEED = 5;  

  Boid(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(-1,1),random(-1,1));
    location = new PVector(x,y);
    MAX_SPEED += random(-.5f, .5f);
  }

  public void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
    velocity.x += random(-.2f,.2f);
    velocity.y += random(-.2f,.2f);
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  public void flock(ArrayList<Boid> boids) {
    PVector attraction = followNeighbors(boids);   // Separation
    applyForce(attraction);
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

    r = 5 * velocity.mag()/MAX_SPEED+1;
    r = 3;

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

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  public PVector followNeighbors (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {

      float d = PVector.dist(location, other.location);
      PVector direction = PVector.sub(other.location, location);
      Boolean isInWalkingDirection = PVector.angleBetween(direction, velocity) < PI/2;
      Boolean similarWalkingDirection = PVector.angleBetween(other.velocity, velocity) < PI/2;
      
      //println(PVector.angleBetween(direction, velocity));

      if ((d > 0) && (d < neighbordist) && isInWalkingDirection && similarWalkingDirection) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(random(-1, 1),random(-1, 1));
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
    String[] appletArgs = new String[] { "a_ant_follow" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
