// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class

// modified and extended by moritz@stefaner.eu for insect smarts workshop

class Boid {

  PVector location;
  PVector velocity;
  PVector acceleration;

  // size (radius)
  float r;
  
  boolean prey = true;

  ArrayList<PVector> history = new ArrayList<PVector>();

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 2.0;

    MAX_FORCE = .1;
  }

  void run(){
  }
  void run(ArrayList<Boid> boids){
  }
  
  void run(ArrayList<Boid> boids, ArrayList<Boid> predators) {
    flock(boids, predators);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, ArrayList<Boid> predators) {
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

    applyForce(attractToMouse());
    
    PVector flee = new PVector(0,0);
    int count = 0;
    for(Boid p: predators){
      if(PVector.dist(location, p.location) < 100){
        PVector fleeDirection = seek(p.location);
        fleeDirection.mult(-5);
        flee.add(fleeDirection);
        count++;
      }
    }
    if(count > 0){
      flee.div(count);
      applyForce(flee);  
    }
  }

  PVector attractToMouse() {
    PVector mousePos = new PVector(mouseX, mouseY);
    PVector result = new PVector();
    if (PVector.dist(location, mousePos)<100) {
      result = seek(mousePos);
      result.mult(-5);
    }

    return result;
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

    history.add(new PVector(location.x, location.y));
    while (history.size () > TRAIL_LENGTH) {
      history.remove(0);
    }
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(MAX_SPEED);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(MAX_FORCE);  // Limit to maximum steering force
    return steer;
  }


  void render() {
    // draw history
    PVector lastLoc = location;
    float decay;
    int col1 = color(0.8, .8, .2);
    int col2 = color(0, .5, .8);

    if(!prey) {
      col1 = color(1,1,1);
      col2 = color(1,1,1);
    }
    //int col2 = color(random(360.0f)/360.0f, random(100)/100.0f, random(100)/100.0f);
    //int col1 = color(random(360.0f)/360.0f, random(100)/100.0f, random(100)/100.0f);
    for (int i=history.size ()-1; i>=0; i-=10) {
      PVector p = history.get(i);
      decay = float(i)/TRAIL_LENGTH;
      if (Math.abs(lastLoc.x-p.x)<=width-20 && Math.abs(lastLoc.y-p.y)<=height-20) {

        int mixedCol = color(hue(col1)*decay + hue(col2)*(1-decay), saturation(col1)*decay + saturation(col2)*(1-decay), brightness(col1)*decay + brightness(col2)*(1-decay), .5f);

        stroke(mixedCol);

        strokeWeight(4 * (float)Math.sqrt(decay));
        //ellipse(lastLoc.x, lastLoc.y, 100*(float)Math.sqrt(decay), 100*(float)Math.sqrt(decay));
        //line(lastLoc.x, lastLoc.y, p.x, p.y);
        point(p.x, p.y);
      }
      lastLoc = p;
    }
    
    r = 3*velocity.mag()/MAX_SPEED;
     
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
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
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
  PVector align (ArrayList<Boid> boids) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < NEIGHBOR_DIST)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(MAX_SPEED);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(MAX_FORCE);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {

    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < NEIGHBOR_DIST)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }
}

