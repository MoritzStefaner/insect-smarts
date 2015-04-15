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

class SimpleAnt {

	PVector location;
	PVector velocity;
	PVector acceleration;

	float MAX_SPEED = 5;

	SimpleAnt(float x, float y) {
		location = new PVector(x,y);
		velocity = new PVector(random(-1,1),random(-1,1));
		acceleration = new PVector(0,0);
	}

	void run() {
		update();
		borders();
		render();
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

