class Mover {

  PVector position;
  PVector velocity;
  int radius;

 Mover(float posx_ini, float posy_ini,float vel_ini_x, float vel_ini_y, int radi) {
    position = new PVector(posx_ini,posy_ini);
    velocity = new PVector(vel_ini_x,vel_ini_y);
    radius = radi;
  }
  
  void update() {
    position.add(velocity);
  }

  void display() {
    stroke(0);
    strokeWeight(3);
    fill(255,200);
    circle(position.x, position.y, radius);
  }
  

}
