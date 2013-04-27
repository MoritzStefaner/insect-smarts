import processing.opengl.*;

import teilchen.Particle;
import teilchen.Physics;

/**
 * this sketch show how to create a particle system with a single particle in it.
 */

Physics mPhysics;

Particle mParticle;

void setup() {
  size(640, 480, OPENGL);
  smooth();
  frameRate(30);

  /* create a particle system. */
  mPhysics = new Physics();

  /*
   * a physic-based particle system consists of a few components.
   *
   * 1 particles.
   * there are different kinds of particles. for now we use a simple particle.
   *
   * 2 forces.
   * there are all kinds of forces. one of the most obvious force is the gravitational force,
   * but there all kinds of different forces like attractors and springs. forces usually
   * affect all particles in the system.
   *
   * 3 behaviors
   * a behavior is special kind of force. it is something like an internal force or a motor
   * that only affects a single particle. a typical force is for example the 'seek force'
   * which constantly pulls a particle into a certain direction.
   *
   * 4 integrators.
   * integrators are used to integrate acceleration and velocity to calculate the new position.
   * the most well-known is the 'euler' integrator, but there are also optimized versions like 'runge-kutta'
   * or 'Midpoint' or even slightly different concepts like 'verlet'.
   *
   */

  /* create a particle. note that the particle is automatically added to particle system */
  mParticle = mPhysics.makeParticle();
}

void draw() {
  /* update the particle system to the next step. usually the time step is the duration of the las frame */
  final float mDeltaTime = 1.0 / frameRate;
  mPhysics.step(mDeltaTime);

  /* draw particle */
  background(255);
  stroke(0, 127);
  fill(0, 32);
  ellipse(mParticle.position().x, mParticle.position().y, 12, 12);

  /* reset particle s position and velocity */
  if (mousePressed) {
    mParticle.position().set(mouseX, mouseY);
    mParticle.velocity().set(mouseX - pmouseX, mouseY - pmouseY);
    mParticle.velocity().scale(10);
  }
}

