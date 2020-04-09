class Mover {

  PVector position;
  PVector velocity;
  PVector acceleration;

  Mover(float vel_ini_x, float vel_ini_y) {
    position = new PVector(0,0);
    velocity = new PVector(vel_ini_x,vel_ini_y);
    acceleration = new PVector(0,0.098);
  }
  
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    //fill(0,0,144,200);
    fill(255,200);
    circle(position.x, position.y, 8);
  }


}
