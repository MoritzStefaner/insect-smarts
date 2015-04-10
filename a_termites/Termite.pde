/*

 I-N°S.E-C:T
 S.M-A°R:T.S

 Moritz Stefaner (moritz@stefaner.eu)
 Dominikus Baur (do@minik.us)
 https://github.com/MoritzStefaner/insect-smarts

 */

class Termite {

  PVector location;
  PVector velocity;
  Boolean carriesWood = false;
  Boolean action = false;
  float woodAge = 0;
  
  // states:
  // 0 - looking for wood
  // 1 - carrying wood, looking for pile
  // 2 - carrying wood, found pile, trying to drop it
  // 3 - fleeing from pile
  int state = 0;

  Termite() {
    location = new PVector((int) random(MAP_WIDTH),(int) random(MAP_HEIGHT));
    velocity = pickRandomVelocity(1);
  }

  PVector pickRandomVelocity(int l) {
    /*
    PVector v = new PVector(random(-1,1),random(-1,1));
    v.setMag(1);
    return v;
    */
    switch((int)random(4)){
      case 0:
        return new PVector(l,0);
      case 1:
        return new PVector(-l,0);
      case 2:
        return new PVector(0,l);
    }
    return new PVector(0,-l);

  }
  
  void update(){
    // pick new (valid) velocity:
    velocity = pickRandomVelocity(1);
    PVector currentPos = new PVector(location.x, location.y);
    PVector fastVelocity = pickRandomVelocity(5);
    
    if(state == 0){
      // doesn't carry wood - find new one!
      if(thereIsWoodAt(currentPos)){
        // pick up
        carriesWood = pickUpWood(currentPos);
        // move a good bit
        currentPos.add(fastVelocity);
        
        state = 1;  
      } else {
        currentPos.add(velocity);
      }
    } else if(state == 1){
      if(!thereIsWoodAt(currentPos)){
        // keep on looking
      } else {
        // found pile!
        state = 2;       
      }
      currentPos.add(velocity);
    } else if(state == 2){
        if(!thereIsWoodAt(currentPos)){
          dropWood(currentPos);
          // flee
          state = 3;
        } else {
          currentPos.add(velocity);
        }
    } else if(state == 3){
      // flee!
      currentPos.add(fastVelocity);
      
      // only stop fleeing once a pile-less location has been reached
      if(!thereIsWoodAt(currentPos)){
        state = 0;
      }
    }
    location = currentPos;

    location.x = (location.x + MAP_WIDTH) % MAP_WIDTH;
    location.y = (location.y + MAP_HEIGHT) % MAP_HEIGHT;
  }

  Boolean pickUpWood(PVector location) {
    woodAge = getWoodAge(location);
    woodMap.stroke(255);
    woodMap.strokeWeight(1);
    woodMap.point((int) location.x, (int) location.y);

    return true;
  }

  Boolean dropWood(PVector location) {
    location.x = (location.x + MAP_WIDTH) % MAP_WIDTH;
    location.y = (location.y + MAP_HEIGHT) % MAP_HEIGHT;
    if(thereIsWoodAt(location)){
      // there is food already here!
      return false ;
    } else {
      woodMap.stroke(woodAge);
      woodMap.strokeWeight(1);
      woodMap.point((int) location.x, (int) location.y);
      carriesWood = false;
      return true;
    }

  }

  float getWoodAge(PVector location){
    return brightness(woodMap.get((int)location.x, (int)location.y));
  }
  
  Boolean thereIsWoodAt(PVector location){
    return brightness(woodMap.get((int) location.x, (int) location.y)) < 255;
  }

  void draw() {
    strokeWeight(1);
    if(action){
      stroke(255,50,0);
    } else {
      if(carriesWood){
        stroke(50);
      } else {
        stroke(200);
      }
    }
    point(location.x, location.y);
  }
}
