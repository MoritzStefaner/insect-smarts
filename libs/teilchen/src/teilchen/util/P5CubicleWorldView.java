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


package teilchen.util;


import mathematik.TransformMatrix4f;
import mathematik.Vector3f;

import teilchen.cubicle.CubicleAtom;
import teilchen.cubicle.CubicleWorld;
import processing.core.PApplet;


public class P5CubicleWorldView {

    private final CubicleWorld _myWorld;

    public P5CubicleWorldView(CubicleWorld theWorld) {
        _myWorld = theWorld;
    }


    public void draw(PApplet theParent) {

        /* collect data */
        final CubicleAtom[][][] myData = _myWorld.getDataRef();
        final TransformMatrix4f myTransform = _myWorld.transform();
        final Vector3f myScale = _myWorld.cellscale();

        /* draw world */
        theParent.pushMatrix();

        /* rotation */
        float[] f = myTransform.toArray();
        theParent.translate(f[12], f[13], f[14]);
        theParent.applyMatrix(f[0], f[1], f[2], f[3],
                              f[4], f[5], f[6], f[7],
                              f[8], f[9], f[10], f[11],
                              0, 0, 0, f[15]);

        /* scale */
        theParent.scale(myScale.x, myScale.y, myScale.z);
        for (int x = 0; x < myData.length; x++) {
            for (int y = 0; y < myData[x].length; y++) {
                for (int z = 0; z < myData[x][y].length; z++) {
                    CubicleAtom myCubicle = myData[x][y][z];
                    theParent.pushMatrix();
                    theParent.translate(x, y, z);
                    if (myCubicle.size() > 0) {
                        theParent.stroke(255, 128, 0, 200);
                    } else {
                        theParent.stroke(255, 255, 255, 127);
                    }
                    theParent.box(1);
                    theParent.popMatrix();
                }
            }
        }
        theParent.popMatrix();
    }
}
