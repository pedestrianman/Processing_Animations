class Mover {

  PVector position;
  float mass;
  PVector velocity;
  
  Mover(float posx_ini, float posy_ini, float masa) {
    position = new PVector(posx_ini,posy_ini);
    mass = masa;
  }
  
  void update(PVector factor, float posx_ini, float posy_ini) {
    position.x = factor.x + posx_ini;
    position.y = factor.y + posy_ini;
    
  }

  void display(int indx_part) {
    
    noStroke();
    switch(indx_part) {
      case 0: 
        fill(255,0,0);
        break;
      case 1: 
        fill(0,255,0);
        break;
      case 2: 
        fill(0,0,255);
        break;
      case 3: 
        fill(255,255,0);
        break;
    }
    
    circle(position.x, position.y, 15);
  }

  void arrow(float x1, float y1, float x2, float y2) {
        
        stroke(15,82,186,200);
        strokeWeight(4);
        line(x1, y1, x2, y2);
        pushMatrix();
        translate(x2, y2);
        float a = atan2(x1-x2, y2-y1);
        rotate(a);
        line(0, 0, -10, -10);
        line(0, 0, 10, -10);
        popMatrix();
      } 
      
  void display_cohete() {
      
      
      noStroke(); 
      fill(255,255,0);
      circle(position.x, position.y, 2);
    
  }

}
