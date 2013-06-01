// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

// modifed by moritz@stefaner.eu for insect smarts workshop

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    // if there are not enough boids, add new ones
    while (boids.size()<NUM_BOIDS)
      addBoid(new Boid(random(width),random(height)));

    // if there are too many, remove them
    while (boids.size()>NUM_BOIDS)
      boids.remove(0);

    // tell each boid to do its thing
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}
