// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

// modifed by moritz@stefaner.eu for insect smarts workshop

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  ArrayList<Boid> predators;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    predators = new ArrayList<Boid>();
    
    for(int i = 0; i < 10; i++){
      Predator pred = new Predator(random(width), random(height));
      predators.add(pred);
    }
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
      b.run(boids, predators);  // Passing the entire list of boids to each boid individually
    }
    
    for (Boid p: predators){
      p.run(boids);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}

