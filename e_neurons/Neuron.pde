float RANDOM_FIRE = .01;
float DECAY = .03;

class Neuron{
	int x;
	int y;
	float activation; 
	ArrayList<Axon> outgoingAxons;
	
	Neuron (){
		x = (int) random(width);
		y = (int) random(height);
		activation = random(2);
		outgoingAxons = new ArrayList<Axon>();
	}

	void run(){
		render();
		activation *= (1-DECAY);
		if(activation > 1 || random(1)<RANDOM_FIRE){
			for (Axon a : outgoingAxons) {
				if(!a.isFiring){
					a.fire();
				}
			}
		}
	}

	void render(){
		stroke(0, 0, 1);
		strokeWeight(activation*5);
		point(x, y);
	}
}