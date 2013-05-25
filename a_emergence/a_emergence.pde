// a_emergence

// author: Moritz Stefaner
// for insect smarts workshop
// May 2013

// see

float x = 0;
float y = 0;
PGraphics result;
PVector wayHome;

void setup(){
	size(200,200, P2D);
	background(0);
	frameRate(500);
	smooth();
	result = createGraphics(width, height);
	result.beginDraw();
	result.smooth();
	result.stroke(255);
	result.strokeWeight(2);
	result.point(width/2, height/2);
	result.endDraw();

	createThing();
}

void draw(){
	
	//println("*");

	//x += (width/2 - x) * .1;
	//y += (height/2 - y) * .1;

	float newX = x + wayHome.x;
	float newY = y + wayHome.y;

	//float newX = x + (width/2 - x) * .2;
	//float newY = y + (height/2 - y) * .2;

	color pixel = result.get((int) newX, (int) newY);
	
	if(brightness(pixel)>0){
		result.beginDraw();
		result.stroke(255);
		result.noSmooth();
		result.strokeWeight(3);
		result.point((int) x, (int) y);
		result.endDraw();

		createThing();
	} else {
		x = newX;
		y = newY;	
	}

	

	background(0);
	image(result, 0,0);
	stroke(255);
	strokeWeight(2);
	point((int) x, (int) y);
}

void createThing(){
	float angle = random(2*PI);
	//println("**");
	//println(angle);
	x = width/2 + cos(angle) * width/2;
	y = height/2 + sin(angle) * height/2;
	wayHome = new PVector(width/2-x, height/2-y);
	wayHome.setMag(5);
	//println(x);
	//println(y);
}
