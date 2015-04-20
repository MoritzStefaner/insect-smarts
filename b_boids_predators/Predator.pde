// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class

// modified and extended by moritz@stefaner.eu for insect smarts workshop

class Predator extends Boid {

  ArrayList<PVector> history = new ArrayList<PVector>();

  Predator(float x, float y) {
    super(x,y);
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    location = new PVector(x, y);
    r = 2.0;
  }
  
  void run(ArrayList<Boid> prey){
    // find the closest prey
    float closest = 999999999;
    Boid closeBoid = new Boid(0,0);
    for(Boid b: prey){
      if(PVector.dist(location, b.location) < closest){
        closest = PVector.dist(location, b.location);
        closeBoid = b;
      }
    }
    
    applyForce(seek(closeBoid.location));
    
    MAX_SPEED *= 0.5f;
    update();
    MAX_SPEED /= 0.5f;
    borders();
    render();
  }
 
  void render(){
    fill(1,1,0.5);
    ellipse(location.x, location.y, 15,15);
  }
  
    // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
}
