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


package teilchen.constraint;


import mathematik.Util;
import mathematik.Vector3f;

import teilchen.Particle;
import teilchen.Physics;


/** @todo
 * it probably pays of two check if we deal with a 2D or 3D constraint.
 * it s just checking components once and then saving a lot of time.
 */

public class Angular
    implements IConstraint {

    private final Particle _myA;

    private final Particle _myB;

    private final Particle _myC;

    private final Vector3f _myTempA = new Vector3f();

    private final Vector3f _myTempB = new Vector3f();

    private float _myMinimumAngle;

    private float _myMaximumAngle;

    private final Vector3f _myTempNormal;

    public boolean OK;

    private static final double EPSILON = 0.001;

    private static final double _myStrength = 1;

    public Angular(Particle theA, Particle theB, Particle theC,
                   float theMinimumAngle, float theMaximumAngle) {
        _myA = theA;
        _myB = theB;
        _myC = theC;
        _myTempNormal = new Vector3f();
        range(theMinimumAngle, theMaximumAngle);
    }


    public Angular(Particle theA, Particle theB, Particle theC) {
        this(theA,
             theB,
             theC,
             0, 0);
    }


    public void range(float theMinimumAngle, float theMaximumAngle) {
        _myMinimumAngle = theMinimumAngle;
        _myMaximumAngle = theMaximumAngle;
        sortAngles();
    }


    public float minimumAngle() {
        return _myMinimumAngle;
    }


    public float maximumAngle() {
        return _myMaximumAngle;
    }


    private void sortAngles() {
        final float myMaximumAngle = _myMaximumAngle;
        final float myMinimumAngle = _myMinimumAngle;
        _myMaximumAngle = Math.max(myMaximumAngle, myMinimumAngle);
        _myMinimumAngle = Math.min(myMaximumAngle, myMinimumAngle);
    }


    public void apply(Physics theParticleSystem) {

        /** @todo test for special case: a and c are in the same place. */

        _myTempA.sub(_myB.position(), _myA.position());
        _myTempB.sub(_myB.position(), _myC.position());

        _myTempA.normalize();
        _myTempB.normalize();

        /** @todo check for special cases! like angle being 0 etc. */

        /** @todo check if the range exceeds PI. */
        if (_myMinimumAngle < Math.PI && _myMaximumAngle > Math.PI) {
            System.out.println("### WARNING split range and check twice.");
        }

        float myCosinusAngle = _myTempA.dot(_myTempB);
        if (myCosinusAngle > 1) {
            System.out.println("### WARNING myCosinusAngle > 1: " + myCosinusAngle);
            myCosinusAngle = 1;
        }

        final float myTempCosMaximumAngle = (float) Math.cos(_myMaximumAngle);
        final float myTempCosMinimumAngle = (float) Math.cos(_myMinimumAngle);
        final float myCosMaximumAngle = Math.max(myTempCosMinimumAngle, myTempCosMaximumAngle);
        final float myCosMinimumAngle = Math.min(myTempCosMinimumAngle, myTempCosMaximumAngle);

        calculateNormal(_myTempA, _myTempB);
        final boolean myLeftSide = checkForHemisphere(_myTempA, _myTempB);
        double myCurrentAngle = 0;

        /** @todo until i the split is implemented agular constraints only work for one side. */
        OK = myLeftSide;

        if (myLeftSide) {
            if (myCosinusAngle < myCosMinimumAngle || myCosinusAngle > myCosMaximumAngle) {
                myCurrentAngle = Math.acos(myCosinusAngle);
                OK = false;
            } else {
                OK = true;
            }
        } else {
            myCurrentAngle = 2 * Math.PI - Math.acos(myCosinusAngle);
        }

        if (!OK) {
            final double myTheta;
            if (myCurrentAngle > _myMaximumAngle) {
                myTheta = _myMaximumAngle - myCurrentAngle;
            } else if (myCosinusAngle < _myMinimumAngle) {
                myTheta = -1 * (myCurrentAngle - _myMinimumAngle);
            } else {
                System.out.println("### WARNING puzzled.");
                myTheta = 0;
            }

            correctAngle(myTheta);
        }
    }


    private void calculateNormal(Vector3f myVectorA, Vector3f myVectorB) {
        _myTempNormal.cross(myVectorA, myVectorB);
        _myTempNormal.normalize();
        if (_myTempNormal.isNaN()) {
            _myTempNormal.set(0, 0, 1);
            System.out.println("### WARNING can t find normal.");
        }
    }


    private void correctAngle(double theTheta) {
        if (theTheta < -EPSILON || theTheta > EPSILON) {

            Vector3f myOtherPointOnAxis = Util.add(_myB.position(), _myTempNormal);

            Vector3f myRotatedPointA = Util.rotatePoint(_myA.position(), theTheta * -0.5 * _myStrength,
                                                        _myB.position(),
                                                        myOtherPointOnAxis);
            _myA.position().set(myRotatedPointA);

            Vector3f myRotatedPointB = Util.rotatePoint(_myC.position(), theTheta * 0.5 * _myStrength,
                                                        _myB.position(),
                                                        myOtherPointOnAxis);
            _myC.position().set(myRotatedPointB);

            System.out.println("correct " + Math.toDegrees(theTheta) + " / " + _myTempNormal);
        }
    }


    private boolean checkForHemisphere(Vector3f myVectorA, Vector3f myVectorB) {
        /* special case thus easy to find the direction */
        if (myVectorA.z == 0 && myVectorB.z == 0) {
            return _myTempNormal.z > 0;
        } else {
            /**
             * @todo
             * do it the hard way and create a matrix from the
             * two vectors and transform the cross vector into
             * local space
             */
            System.out.println("### WARNING calculate for 3D plane / not implemented.");
            return true;
        }
    }
}
