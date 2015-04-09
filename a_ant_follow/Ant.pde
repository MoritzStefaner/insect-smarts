/*

 I-N°S.E-C:T
 S.M-A°R:T.S

 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts

 based on code from http://natureofcode.com

 */


float MAX_FORCE = 10;
float WIGGLE = 1;
float LOOK_ANGLE = .25;

class Ant {

	PVector location;
	PVector velocity;
	PVector acceleration;

	float MAX_SPEED = 5;

	Ant(float x, float y) {
		location = new PVector(x,y);
		velocity = new PVector(random(-1,1),random(-1,1));
		acceleration = new PVector(0,0);
		MAX_SPEED += random(-1, 1);
	}

	void run(ArrayList<Ant> ants) {
		PVector attraction = followNeighbors(ants);
		applyForce(attraction);

		update();
		borders();
		render();
	}

	// For the average location (i.e. center) of all nearby ants, calculate steering vector towards that location
	PVector followNeighbors (ArrayList<Ant> ants) {
		PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
		int count = 0;
		for (Ant other : ants) {
			float d = PVector.dist(location, other.location);
			PVector direction = PVector.sub(other.location, location);
			Boolean isInWalkingDirection = PVector.angleBetween(direction, velocity) < LOOK_ANGLE * 2 * PI;
			Boolean similarWalkingDirection = PVector.angleBetween(other.velocity, velocity) < LOOK_ANGLE * 2 * PI;

			if ((d > 0) && (d < NEIGHBOR_DIST) && isInWalkingDirection && similarWalkingDirection) {
				sum.add(other.location); // Add location
				count++;
			}
		}

		if (count > 0) {
			sum.div(count);
			return seek(sum);  // Steer towards the location
		} else {
			// wiggle
			return new PVector(random(-1, 1),random(-1, 1));
		}
	}

	void applyForce(PVector force) {
		// We could add mass here if we want A = F / M
		acceleration.add(force);
	}

	// Method to update location
	void update() {
		// Update velocity
		velocity.add(acceleration);

		// wiggle a little
		wiggle();

		// Limit speed
		velocity.limit(MAX_SPEED);

		// apply speed
		location.add(velocity);

		// Reset acceleration to 0 each cycle
		acceleration.mult(0);
	}

	void wiggle() {
		velocity.x += random(-WIGGLE, WIGGLE);
		velocity.y += random(-WIGGLE, WIGGLE);
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
		// the image is turned 45 degreed
		rotate(velocity.heading2D() + PI/4);
		image(antImage, 0,0);
		popMatrix();
	}

	// Wraparound
	void borders() {
		location.x = (location.x + width) % width;
		location.y = (location.y + height) % height;
	}



}

