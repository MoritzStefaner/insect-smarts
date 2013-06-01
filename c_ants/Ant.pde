/* 
  
  I-N°S.E-C:T 
  S.M-A°R:T.S

  Moritz Stefaner (moritz@stefaner.eu), May 2013
  https://github.com/MoritzStefaner/insect-smarts

  based on http://natureofcode.com

 */

class Ant {

  PVector location;
  PVector direction;
  PVector home;

  Boolean carriesFood = false;
  Boolean action = false;

  int pheroPower = 0;

  Ant() {

    home = new PVector(width/2, height/2);
    location = new PVector(home.x, home.y);
    direction = pickDirection();
  }


  void run() {
    update();
    render();
  }


  PVector pickDirection() {
    // first, check pheroMap
    int bestPhero = 255;
    int pheroTest = 255;
    PVector newDirection = new PVector(0,0);

    // look around
    int numSteps = 32;
    float start = random(1f);
    for (int i=0; i<numSteps; i++){
      float angle = (start+1.0f*i/numSteps)*TWO_PI;
      PVector testDirection = new PVector((float) Math.cos(angle), (float) Math.sin(angle));
      color col = pheroMap.get((int) (location.x+testDirection.x + width) % width, (int) (location.y + testDirection.y + height) % height );
      pheroTest = (int) brightness(col);
      
      if( pheroTest < bestPhero){
          newDirection = testDirection;
          bestPhero = pheroTest;
      }
    }

    if(newDirection.mag()>.001) {
      // we found a good smell, go in that direction
      return newDirection;
    }

    // else: random direction
    newDirection = new PVector(random(-1f, 1f), random(-1f, 1f));
    newDirection.setMag(1);
    return newDirection;
  }

  Boolean isAtHome() {
    return new PVector(location.x-home.x, location.y-home.y).mag()<10;
  }
 
  // Method to update location
  void update() {

    if(!carriesFood && random(100)>80 && brightness(pheroMap.get((int)location.x, (int)location.y)) == 255) {
      // pick a random direction sometimes, if nothing special is around
      direction = pickDirection();
    }

    if(carriesFood){
      // if we carry food, navigate home
      direction = new PVector(home.x - location.x, home.y - location.y);
      direction.setMag(1);
    }

    if(isAtHome() && carriesFood){
      // if we are at home drop food and start again
      dropFood(location);
      pickDirection();
    }

    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);

    nextPos.x = (nextPos.x + width) % width;
    nextPos.y = (nextPos.y + height) % height;
    
    color col = foodMap.get((int) nextPos.x, (int) nextPos.y);

    if(brightness(col) < 255 && !carriesFood){
        // ha! We found food!
        action = true;
        carriesFood = pickUpFood(nextPos);
    } else{
      action = false;
    }
    location = nextPos;

    if(carriesFood && pheroPower>0){
      // draw a trail for the others
      pheroMap.pushMatrix();
      pheroMap.imageMode(CENTER);
      pheroMap.translate(location.x, location.y);
      pheroMap.scale(pheroPower/100.0);
      pheroMap.tint(255, pheroPower/2);
      pheroMap.image(pheromapImage,0, 0);
      pheroMap.popMatrix();
      pheroPower--;
    }

  }

  Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(3);
    foodMap.point((int) location.x, (int) location.y);
    pheroPower = (int) (new PVector(home.x - location.x, home.y - location.y).mag());
    return true;
  }
  
  Boolean dropFood(PVector location) {
    carriesFood = false;
    return true;
  }

  void render() {    
    if(action){
      // draw a bigger red circle for actions
      stroke(255,0,0);  
      strokeWeight(2); 
    } else {
      stroke(0);
      if(carriesFood){
        // draw bigger when carrying food
        strokeWeight(3);  
      } else {
        // default
        strokeWeight(2);  
      } 
    }
    point(location.x, location.y);
  }
}
