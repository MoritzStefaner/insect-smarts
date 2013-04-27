/*
 * Teilchen
 *
 * Copyright (C) 2013
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * {@link http://www.gnu.org/licenses/lgpl.html}
 *
 */


package teilchen.demo;


import processing.core.PApplet;
import teilchen.Particle;
import teilchen.Physics;
import teilchen.force.Spring;
import teilchen.util.AntiOverlap;


/**
 * this sketch is exactly like Lesson06_Springs, except that it also shows how
 * to remove overlaps.
 */
public class LessonX01_Overlap
        extends PApplet {

    private Physics mPhysics;

    private Particle mRoot;

    private static final float PARTICLE_RADIUS = 6;

    public void setup() {
        size(640, 480, OPENGL);
        smooth();
        frameRate(30);

        mPhysics = new Physics();
        mRoot = mPhysics.makeParticle(width / 2, height / 2, 0.0f);
        mRoot.mass(30);
    }

    public void draw() {
        if (mousePressed) {
            Particle mParticle = mPhysics.makeParticle(mouseX, mouseY, 0);
            Spring mSpring = mPhysics.makeSpring(mRoot, mParticle);
            float mRestlength = mSpring.restlength();
            mSpring.restlength(mRestlength * 1.5f);

            /*
             * we define a radius for the particle so the particle has
             * dimensions
             */
            mParticle.radius(PARTICLE_RADIUS);
        }

        /* move overlapping particles away from each other */
        AntiOverlap.remove(mPhysics.particles());

        /* update the particle system */
        final float mDeltaTime = 1.0f / frameRate;
        mPhysics.step(mDeltaTime);

        /* draw particles and connecting line */
        background(255);

        /* draw springs */
        noFill();
        stroke(255, 0, 127, 64);
        for (int i = 0; i < mPhysics.forces().size(); i++) {
            if (mPhysics.forces().get(i) instanceof Spring) {
                Spring mSSpring = (Spring)mPhysics.forces().get(i);
                line(mSSpring.a().position().x, mSSpring.a().position().y,
                     mSSpring.b().position().x, mSSpring.b().position().y);
            }
        }
        /* draw particles */
        fill(245);
        stroke(164);
        for (int i = 0; i < mPhysics.particles().size(); i++) {
            ellipse(mPhysics.particles().get(i).position().x,
                    mPhysics.particles().get(i).position().y,
                    PARTICLE_RADIUS * 2, PARTICLE_RADIUS * 2);
        }
    }

    public static void main(String[] args) {
        PApplet.main(new String[] {LessonX01_Overlap.class.getName()});
    }
}
