// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Flock class
// Does very little, simply manages the ArrayList of all the boids

// edit mo: change to "Ants"

class Flock {
  ArrayList<Ant> ants; // An ArrayList for all the ants
  
  Flock() {
    ants = new ArrayList<Ant>(); // Initialize the ArrayList
  }

  void run() {
    while (ants.size()<NUM_BOIDS)
      addAnt(new Ant(random(width),random(height)));

    while (ants.size()>NUM_BOIDS)
      ants.remove(0);

    for (Ant b : ants) {
      b.run(ants);  // Passing the entire list of ants to each boid individually
    }
  }

  void addAnt(Ant b) {
    ants.add(b);
  }
}
