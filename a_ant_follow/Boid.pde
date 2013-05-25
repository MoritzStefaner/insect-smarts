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
    MAX_SPEED += random(-.5, .5);
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
    velocity.x += random(-.2,.2);
    velocity.y += random(-.2,.2);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector attraction = followNeighbors(boids);   // Separation
    applyForce(attraction);
  }

  // Method to update location
  void update() {
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
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(MAX_SPEED);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(MAX_FORCE);  // Limit to maximum steering force
    return steer;
  }
  
  void render() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading2D() + 45);
    image(antImage, 0,0);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector followNeighbors (ArrayList<Boid> boids) {
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

