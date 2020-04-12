class Mover {

  PVector position;
  PVector velocity;

  Mover(float posx_ini, float posy_ini,float vel_ini_x, float vel_ini_y) {
    position = new PVector(posx_ini,posy_ini);
    velocity = new PVector(vel_ini_x,vel_ini_y);
  }
  
  void update() {
    position.add(velocity);
  }

  void display() {
    noStroke();
    fill(0,0,0,0);
    circle(position.x, position.y, 8);
  }


}
